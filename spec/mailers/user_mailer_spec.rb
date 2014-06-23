require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @account = FactoryGirl.create(:account)
    @user = FactoryGirl.create(:user)
    @account.user_id = @user.id
    @account.save

    UserMailer.daily_report(@account).deliver
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it 'should send an email' do
    ActionMailer::Base.deliveries.count.should == 1
  end

end
