class Instance < ActiveRecord::Base
  belongs_to :account

  def start
    self.account.set_aws_credentials
    ec2 = Aws::EC2::Client.new
    ec2.start_instances( {instance_ids:[self.instance_id]})
    begin
      ec2.wait_until(:instance_running, instance_ids:[self.instance_id])
      return 'instance running'
    rescue Aws::Waiters::Errors::WaiterFailed => error
      return "failed waiting for instance to start: #{error.message}"
    end
  end


  def stop
    self.account.set_aws_credentials
    ec2 = Aws::EC2::Client.new
    ec2.stop_instances( {instance_ids:[self.instance_id]})
    begin
      ec2.wait_until(:instance_stopped, instance_ids:[self.instance_id])
      return 'instance stopped'
    rescue Aws::Waiters::Errors::WaiterFailed => error
      return "failed waiting for instance to stop: #{error.message}"
    end
  end

end
