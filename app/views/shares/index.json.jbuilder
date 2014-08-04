json.array!(@shares) do |share|
  json.extract! share, :name, :root, :secrets, :block_size, :block_count, 
    :trans_bytes, :created_at, :updated_at
end
