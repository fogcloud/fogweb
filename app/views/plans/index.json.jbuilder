json.array!(@plans) do |plan|
  json.extract! plan, :id, :name, :megs, :price_usd
  json.url plan_url(plan, format: :json)
end
