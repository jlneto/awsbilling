json.array!(@reports) do |report|
  json.extract! report, :id, :account_id, :period, :value
  json.url report_url(report, format: :json)
end
