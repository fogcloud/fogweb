json.array!(@users) do |user|
  json.extract! user, :id, :email, :plan_id, :credit, :autobill
  json.url user_url(user, format: :json)
end
