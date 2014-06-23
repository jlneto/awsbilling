class UserMailer < ActionMailer::Base

  default from: 'produto@taxweb.com.br'
  helper :application

  def daily_report(account)
    @account = account
    user = account.user
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'AWS Billing Monitor Daily Report')
  end

end
