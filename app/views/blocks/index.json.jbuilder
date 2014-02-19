json.array!(@blocks) do |block|
  json.extract! block, :id, :user_id, :hash
  json.url block_url(block, format: :json)
end
