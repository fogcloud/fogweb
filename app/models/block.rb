
require 'fileutils'
require 'digest/sha2'

class Block
  attr_accessor :name
  attr_accessor :share
  attr_reader :errors

  def initialize(share, name)
    unless name.size == 64
      raise StandardError.new("Invalid block name: [#{name}]")
    end
    @name = name
    @share = share
    @errors = []
  end

  def path
    # Modern filesystems can handle many files in a single
    # directory. If this becomes an issue, we can make it
    # nest deeper.
    d0 = name[0..1]
    share.data_root.join(d0, name)
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
      @errors << "Got block size #{data.size}."
      return
    end

    sha = Digest::SHA2.new
    sha << data

    if sha.hexdigest != @name
      puts "(name = #{@name})"
      puts "(hash = #{sha.hexdigest})"
      @errors << "Block hash mismatch"
      return
    end

    FileUtils.mkdir_p(path.dirname.to_s)

    File.open(path, "wb") do |ff|
      ff.write(data)
    end

    puts "Saved block to #{path}"

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
