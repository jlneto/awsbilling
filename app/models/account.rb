class Account < ActiveRecord::Base
  belongs_to :user
  has_many :reports


  def update_billing_data
    #connect to S3
  end

  def month_to_date_spend

  end

  def last_month_to_date_spend

  end

  def month_estimate_spend

  end

  def last_month_spend

  end

  def month_change_spend

  end


  def day_average_spend

  end

  def yesterday_average_spend

  end

  def day_average_spend_change

  end

  def day_spend

  end

  def yesterday_spend

  end

  def day_spend_change

  end

  def last_update
    self.updated_at
  end



end
