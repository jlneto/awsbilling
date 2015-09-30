json.array!(@instances) do |instance|
  json.extract! instance, :id, :account_id, :name, :description, :instance_id, :instance_type, :availability_zone, :dns_address, :current_address
  json.url instance_url(instance, format: :json)
end
