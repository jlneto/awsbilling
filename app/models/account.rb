class Account < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :instances

  include Ec2Usage

  attr_accessor :reference_date

  def to_s
    self.name
  end

  def s3_region
    'sa-east-1'
  end

  require 'zip/zip'

  def update_billing_data(reference_date)

    @reference_date = reference_date

    Aws.config.update({
                          region: self.s3_region,
                          credentials: Aws::Credentials.new(self.access_key, self.secret),
                      })

    year = @reference_date.year
    month = @reference_date.month.to_s.rjust(2,'0')
    # curr_month = "#{self.aws_account_id}-aws-billing-csv-#{year}-#{month}.csv"
    # curr_month = "#{self.aws_account_id}-aws-billing-detailed-line-items-#{year}-#{month}.csv.zip"
    curr_month = "#{self.aws_account_id}-aws-billing-detailed-line-items-with-resources-and-tags-#{year}-#{month}.csv.zip"

    s3 = Aws::S3::Client.new
    resp = s3.get_object(bucket:self.bucket_name, key:curr_month)

    Zip::InputStream.open(resp.body) do |unzipped|
      zip_entry = unzipped.get_next_entry
      csv_data = zip_entry.get_input_stream.read
      update_report(csv_data)
    end
  end


  def update_report(csv_data)
    period = @reference_date.beginning_of_month
    if period == Date.today.beginning_of_month
      day = @reference_date.day
    else
      # se não é o mes corrente, days e o numero de dias no mês
      day = @reference_date.end_of_month.day
    end
    rep = self.reports.where(period:period).first
    rep = self.reports.create(period:period) unless rep

    parse_billing_data(csv_data, rep)

    rep.reference_day = day

    rep.save!
  end


  require 'csv'

  def parse_billing_data(csv_data, report)
    resp = {total_cost:0, linked_accounts: {} }
    csv = CSV.new(csv_data, :headers => true)
    #  hash usado para armazenar a AZ por resource-id pois, dependendo da operacao, um mesmo recurso pode ou nao ter a informacao de AZ na planilha da AWS
    az_by_resource_id = {}
    dates = {}
    csv.each do |row|
      r = row.to_hash
      if r['RecordType'] == 'LineItem'
        # dates
        rec_date = r['UsageStartDate'].slice(0,10)
        if (dates[rec_date].present?)
          report_lines_for_this_date = dates[rec_date]
        else
          report_lines_for_this_date = {}
        end
        # report_lines
        # agregando por 'servico-resourceId'. Ex: 'Ec2 EBS-i-87a347'
        service_name = define_service_name(r)
        resource_id = r['ResourceId']
        report_line_key = "#{service_name}-#{resource_id}"
        if (report_lines_for_this_date[report_line_key].present?)
          report_line = report_lines_for_this_date[report_line_key]
        else
          parsed_date = Date.parse(rec_date, '%Y-%m-%d')
          report_line = ReportLine.where(:service => service_name).where(:resource_id => resource_id).where(:date => parsed_date).first
          if (report_line.blank?)
            report_line = ReportLine.new
            report_line.product_name = r['ProductName']
            report_line.resource_id = resource_id
            report_line.resource_name = r['user:Name'] || r['user:name']
            if (r['AvailabilityZone'].present?)
              az_by_resource_id[resource_id] = r['AvailabilityZone']
            end
            report_line.az = az_by_resource_id[resource_id]
            report_line.custo = r['user:custo']
            report_line.service = service_name
            report_line.blended_cost = 0
            report_line.unblended_cost = 0
            report_line.date = parsed_date
          end
        end

        report_line.blended_cost += r['BlendedCost'].to_f if r['BlendedCost'].present?
        report_line.unblended_cost += r['UnBlendedCost'].to_f if r['UnBlendedCost'].present?

        report_lines_for_this_date[report_line_key] = report_line
        dates[rec_date] = report_lines_for_this_date
      end
    end

    report_lines = []
    dates.each do |date, report_lines_for_this_date|
      report_lines << report_lines_for_this_date.values
    end

    report.report_lines = report_lines.flatten

    resp
  end


  def define_service_name(row)
    if (row['ProductName'] == 'Amazon Elastic Compute Cloud')
      usage_type = row['UsageType']
      if row['UsageType'].downcase.include?('boxusage') || row['UsageType'].downcase.include?('heavyusage') || row['UsageType'].downcase.include?('spotusage')
          return 'EC2 Instance Usage'
      elsif row['UsageType'].downcase.include?('cw')
          return 'EC2 Cloud Watch'
      elsif row['UsageType'].downcase.include?('ebs')
          return 'EC2 EBS'
      elsif row['UsageType'].downcase.include?('datatransfer')
          return 'EC2 Data Transfer'
      elsif row['UsageType'].downcase.include?('cloudfront')
          return 'EC2 CloudFront'
      elsif row['UsageType'].downcase.include?('dataprocessing') || row['UsageType'].downcase.include?('loadbalancer')
          return 'EC2 Load Balancer'
      else
          return 'EC2 Others'
      end
    else
      return row['ProductName']
    end
  end


  def month_report(date = Date.today)
    period = date.beginning_of_month
    self.reports.where(period: period).first
  end

  def month_to_date_spend
    rep = month_report(@reference_date)
    if rep.present?
      daily_spends = rep.report_lines.where("date <= ?", @reference_date).group('date').sum('unblended_cost')
    end
    month_spend = hash_values_sum(daily_spends)
    month_spend
  end

  def last_month_to_date_spend
    rep = month_report(@reference_date.prev_month)
    if rep.present?
      daily_spends = rep.report_lines.where("date <= ?", @reference_date.prev_month).group('date').group('date').sum('unblended_cost')
    end
    last_month_spend = hash_values_sum(daily_spends)
    last_month_spend
  end

  def month_estimate_spend
    daily_average = day_average_spend
    daily_average * @reference_date.end_of_month.day
  end

  def last_month_spend
    rep = month_report(@reference_date.prev_month)
    if rep.present?
      daily_spends = rep.report_lines.group('date').group('date').sum('unblended_cost')
    end
    last_month_spend = hash_values_sum(daily_spends)
    last_month_spend
  end

  def month_change
    calc_change( month_estimate_spend, last_month_spend )
  end

  def month_to_date_change
    calc_change( month_to_date_spend, last_month_to_date_spend )
  end

  def day_average_spend
    rep = month_report(@reference_date)
    if rep.present?
      daily_spends = rep.report_lines.group('date').sum('unblended_cost')
    end
    daily_average = hash_values_average(daily_spends)
    daily_average
  end

  def previous_average_spend
    rep = month_report(@reference_date.prev_month)
    if rep.present?
      daily_spends = rep.report_lines.group('date').sum('unblended_cost')
    end
    daily_average = hash_values_average(daily_spends)
    daily_average
  end

  def day_average_change
    calc_change(day_average_spend,previous_average_spend)
  end

  def day_spend
    rep = month_report(@reference_date)
    if rep.present?
      daily_spends = rep.report_lines.group('date').sum('unblended_cost')
    end
    if (daily_spends.present?)
      daily_spends[@reference_date]
    else
      0
    end
  end

  def previous_day_spend
    rep = month_report(@reference_date)
    if rep.present?
      daily_spends = rep.report_lines.group('date').sum('unblended_cost')
    end
    if (daily_spends.present?)
      daily_spends[@reference_date.prev_day]
    else
      nil
    end
  end

  def day_spend_change
    calc_change(day_spend,previous_day_spend)
  end

  def last_update
    rep = month_report
    month_report.updated_at if rep
  end

  # Deliver daily reports for all accounts
  def self.deliver_daily_reports
    Account.all.each do |account|
      UserMailer.daily_report(account).deliver
    end
  end

  private
    def hash_values_average(h)
      average = 0
      if (h.present?)
        h.each do |key, value|
          average += value
        end
        average = average / h.length
      end
      average.round(2)
    end

    def hash_values_sum(h)
      sum = 0
      if (h.present?)
        h.each do |key, value|
          sum += value
        end
      end
      sum
    end

    def calc_change(v1,v2)
      if v1 and v2 and v1 != 0
        ((v1-v2)/v1*100).round(1)
      else
        nil
      end
    end

end
