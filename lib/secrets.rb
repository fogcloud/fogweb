
require 'fileutils'
require 'pathname'
require 'securerandom'

class Secrets
  def self.get_hex(name, bytes)
    dir = Pathname.new(File.expand_path("~/.config/rails"))
    FileUtils.mkdir_p(dir)

    file = dir.join(name)

    unless File.exists?(file)
      File.open(file, "w") do |dd|
        dd.puts(SecureRandom.hex(bytes))
      end
    end
      
    File.open(file) do |dd|
      return dd.readline.chomp
    end
  end
end
