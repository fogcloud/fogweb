
class BlockArchive
  def initialize(data = nil, blsz = 16384)
    @data = data
    @blsz = blsz
    
    if @data.nil?
      tmp = Rails.root.join('tmp')
      @data = Tempfile.new("ba", tmp, binmode: true)
    end
  end

  def close
    @data.close
  end

  def path
    @data.path
  end

  def read
    @data.path.read
  end

  def read_block
    hash = @data.read(32)
    if hash.nil? || hash.size != 32
      return nil, nil
    end

    data = @data.read(@blsz)
    if data.nil? || data.size != @blsz
      return nil, nil
    end

    return hash_to_hex(hash), data
  end

  def each
    loop do
      hash, data = read_block
      if hash.nil? || data.nil?
        break
      end

      yield hash, data
    end
  end

  def add(hash, data)
    @data.write(hex_to_hash(hash))
    @data.write(data)
  end

  private

  def hash_to_hex(hash)
    hash.unpack("H*")[0]
  end

  def hex_to_hash(hex)
    [hex].pack("H*")
  end
end

