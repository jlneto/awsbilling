module Ec2Usage
  extend ActiveSupport::Concern

  def set_aws_credentials
    Aws.config.update({
                          region: self.s3_region,
                          credentials: Aws::Credentials.new(self.access_key, self.secret),
                      })
  end


  def ec2_instances
    set_aws_credentials
    ec2 = Aws::EC2::Client.new
    resp = ec2.describe_regions

    # select{|r| r.region_name[0..1].in?(%w(us sa))}.
    regions = resp.regions.map{|r| r.region_name }
    reserved_instances = []
    on_demand_instances = []
    regions.each do |region|
      ec2 = Aws::EC2::Client.new({region: region})
      resp = ec2.describe_reserved_instances

      resp.reserved_instances.each do |reserve|
        reserve.instance_count.times do
          reserved_instances <<  { instance_type: reserve.instance_type,
                                   region: reserve.availability_zone[0..-4],
                                   availability_zone: reserve.availability_zone,
                                   product_description: reserve.product_description,
                                   state: reserve.state }
          end
      end
    end

    regions.each do |region|
      ec2 = Aws::EC2::Client.new({region: region})
      resp = ec2.describe_instances
      resp.reservations.each do |reservation|
        on_demand_instances += reservation.instances.map{ |i| { instance_type: i.instance_type,
                                                                region: i.placement.availability_zone[0..-4],
                                                                availability_zone: i.placement.availability_zone,
                                                                instance_id: i.instance_id,
                                                                state: i.state.name,
                                                                public_ip_address: i.public_ip_address,
                                                                public_dns_name: i.public_dns_name,
                                                                tags: i.tags
                                                              }
                                                            }
      end
    end
    {
        reserved: reserved_instances,
        on_demand: on_demand_instances
    }
  end

  def load_from_aws
    self.ec2_instances[:on_demand].each do |instance|
      instance[:name] = instance_name(instance)
      instance.except!(:tags)
      self.instances.create(instance)
    end
  end

  private

  def instance_name(instance)
    instance[:tags].each do |tag|
      if tag.key.downcase == 'name'
        return tag.value
      end
    end
  end
end
