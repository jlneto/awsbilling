require 'development_mail_interceptor'

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => ENV['DOMAIN_NAME'],
    :user_name            => ENV['GMAIL_USERNAME'],
    :password             => ENV['GMAIL_PASSWORD'],
    :authentication       => "plain",
    :enable_starttls_auto => true
}

#ActionMailer::Base.default_url_options[:host] = "portal.taxweb.com.br"

if Rails.env.development? or Rails.env.staging?
  Mail.register_interceptor(DevelopmentMailInterceptor)
  #ActionMailer::Base.default_url_options[:host] = "localhost:3000"
end

