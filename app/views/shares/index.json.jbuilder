json.array!(@shares) do |share|
  json.extract! share, :id, :name, :root, :blocks
  json.url share_url(share, format: :json)
end
