class Account < ActiveRecord::Base
  belongs_to :user
  # has_many :users
  has_many :reports

  def s3_region
    'sa-east-1'
  end

  def update_billing_data(reference_date)
    AWS.config(access_key_id: self.access_key, secret_access_key: self.secret, region: self.s3_region)
    year = reference_date.year
    month = reference_date.month.to_s.rjust(2,'0')
    curr_month = "#{self.aws_account_id}-aws-billing-csv-#{year}-#{month}.csv"

    s3 = AWS::S3.new
    aws_billing_obj = s3.buckets[self.bucket_name].objects[curr_month]
    csv_data = aws_billing_obj.read
    month_values = parse_billing_data(csv_data)
    update_report reference_date, month_values

  end

  def update_report(reference_date, billing_data)
    period = reference_date.beginning_of_month

    if period == Date.today.beginning_of_month
      day = reference_date.day
    else
      # se não é o mes corrente, days e o numero de dias no mês
      day = reference_date.end_of_month.day
    end

    rep = self.reports.where(period:period).first
    rep = self.reports.create(period:period) unless rep

    rep.reference_day = day
    rep.value = billing_data[:total_cost]

    if day > (rep.reference_day || 1 )
      rep.previous_day_average = rep.day_average
      rep.previous_value = rep.value
      rep.previous_day_spend = rep.day_spend
    end

    if rep.previous_value
      rep.day_spend = rep.value - rep.previous_value
    end

    rep.day_average = (rep.value / day).round(2)
    rep.save!
  end


  require 'csv'

  def parse_billing_data(csv_data)
    resp = {total_cost:0, linked_accounts: {} }
    csv = CSV.new(csv_data, :headers => true)
    csv.to_a.map do |row|
      r = row.to_hash
      if r['RecordType'] == 'InvoiceTotal'
        resp[:total_cost] = r['TotalCost'].to_f
      end
      if r['RecordType'] == 'AccountTotal'
        resp[:linked_accounts][r['LinkedAccountName']] = r['TotalCost'].to_f
      end
    end
    resp
  end

  def month_report(date = Date.today)
    period = date.beginning_of_month
    self.reports.where(period: period).first
  end

  def month_to_date_spend
    rep =month_report(Date.today)
    rep.value if rep
  end

  def last_month_to_date_spend
    days = Date.today.day
    rep = month_report(1.month.ago)
    rep.day_average * days if rep
  end

  def month_estimate_spend
    rep = month_report(Date.today)
    days_in_month = Date.today.end_of_month.day
    rep.day_average * days_in_month if rep
  end

  def last_month_spend
    rep = month_report(1.month.ago)
    rep.value if rep
  end

  def calc_change(v1,v2)
    if v1 and v2 and v1 != 0
      ((v1-v2)/v1*100).round(1)
    else
      nil
    end
  end

  def month_change
    calc_change( month_estimate_spend, last_month_spend )
  end

  def month_to_date_change
    calc_change( month_to_date_spend, last_month_to_date_spend )
  end

  def day_average_spend
    rep = month_report(Date.today)
    rep.day_average if rep
  end

  def previous_average_spend
    rep = month_report(Date.today)
    rep.previous_day_average if rep
  end

  def day_average_change
    calc_change(day_average_spend,previous_average_spend)
  end

  def day_spend
    rep = month_report(Date.today)
    rep.day_spend if rep
  end

  def previous_day_spend
    rep = month_report(Date.today)
    rep.previous_day_spend if rep
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

end
