
require 'fileutils'

class Block < ActiveRecord::Base
  belongs_to :user

  validates :name, length: { is: 64 }

  validate :block_data_is_saved
  validate :check_upload_errors
  after_destroy :cleanup!

  def self.block_size
    4096
  end

  def path
    d0 = name[0..1]
    d1 = name[2..3]
    d2 = name[4..5]
    d3 = name[6..7]
    nn = name[8..-1]
    "/data/#{d0}/#{d1}/#{d2}/#{d3}/#{nn}"
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

    data = upload.read(4096)

    File.open(file, "w") do |ff|
      ff.write(data)
    end
  end

  def cleanup!
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
    return if @upload_errors.nil?
    @upload_errors.each do |ee|
      self.errors[:base] << ee
    end
  end

  def block_data_is_saved
    unless File.file?(file) && File.size(file) == Block.block_size
      self.errors[:base] << "Block was not successfully stored to disk."
    end
  end
end
