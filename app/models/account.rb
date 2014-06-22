class Account < ActiveRecord::Base
  belongs_to :user
  has_many :reports


  def update_billing_data
    #connect to S3


  end

end
