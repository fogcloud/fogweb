
require 'fileutils'

class Block
  attr_accessor :name
  attr_accessor :user_id

  def self.block_size
    65536
  end

  def user
    User.find(user_id)
  end

  def path
    # 4096 entries in each of base, d0, and d1
    # allows for 64G blocks = 256TB
    d0 = name[0..2]
    d1 = name[3..5]
    "/data/#{user.id}/#{d0}/#{d1}/#{name}"
  end
  
  def file
    Rails.root.join("public", path[1..-1])
  end

  def upload=(upload)
    if upload.size != Block.block_size
      @upload_errors ||= []
      @upload_errors << "Block size must be exactly #{Block.block_size} bytes."
      return
    end

    FileUtils.mkdir_p(file.dirname.to_s)

    data = upload.read(Block.block_size)

    File.open(file, "wb") do |ff|
      ff.write(data)
    end

    unless File.file?(file) && File.size(file) == Block.block_size
      @upload_erros ||= []
      @upload_errors << "Block was not successfully stored to disk."
      return
    end
  end

  def remove!
    if file.to_s.length > 10
      begin
        File.unlink(file.to_s)
       
        dd = file.dirname

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

  def check_upload_errors
    return @upload_errors
  end
end
