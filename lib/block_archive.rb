
class BlockArchive
  def initialize(data = nil, blsz = 16384)
    @data = data
    @blsz = blsz
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

    return hash.unpack("H*")[0], data
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
end

