# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    name "MyCompany"
    aws_account_id "123456789"
    bucket_name "Mycomapny-awsbilling"
    access_key "123456789"
    secret "123456789"
  end
end
