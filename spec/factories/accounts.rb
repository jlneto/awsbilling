# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    name "MyString"
    aws_account_id "MyString"
    bucket_name "MyString"
    access_key "MyString"
    secret "MyString"
  end
end
