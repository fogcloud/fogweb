
require 'fileutils'
require 'digest/sha2'

class Block
  attr_accessor :name
  attr_accessor :share
  attr_reader :errors

  def initialize(share, name)
    @name = name
    @share = share
    @errors = []
  end

  def path
    # 2048 entries in each of base, d0, and d1
    # allows for 8G blocks = 512TB with 64k blocks
    d0 = name[0..2]
    d1 = name[3..5]
    share.data_root.join(d0, d1, name)
  end
  
  def save_upload(upload)
    if upload.size != share.block_size
      @errors << "Block size must be exactly #{share.block_size} bytes."
      return
    end

    FileUtils.mkdir_p(path.dirname.to_s)

    data = upload.read(share.block_size)

    File.open(path, "wb") do |ff|
      ff.write(data)
    end

    unless File.file?(path) && File.size(path) == share.block_size
      @errors << "Block was not successfully stored to disk."
      return
    end
  end

  def save_data(data)
    if data.size != share.block_size
      @errors << "Block size must be exactly #{share.block_size} bytes."
      return
    end

    sha = Digest::SHA2.new
    sha << data

    if sha.hexdigest != @name
      @errors << "Block hash mismatch"
      return
    end

    File.open(path, "wb") do |ff|
      ff.write(data)
    end

    unless File.file?(path) && File.size(path) == share.block_size
      @errors << "Block was not successfully stored to disk."
      return
    end
  end

  def data
    path.read
  end

  def remove!
    if path.to_s.length > 10
      begin
        File.unlink(path.to_s)
       
        dd = path.dirname

        loop do
          Dir.rmdir(dd.to_s)
          dd = dd.dirname
        end
      rescue Errno::ENOENT
        # pass
      rescue Errno::ENOTEMPTY
        # pass
      end
    end
  end
end
