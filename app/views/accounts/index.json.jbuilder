json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :aws_account_id, :bucket_name, :access_key, :secret
  json.url account_url(account, format: :json)
end
