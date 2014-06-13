require 'find'
require 'pathname'
require 'fileutils'

class Share < ActiveRecord::Base
  belongs_to :user

  validates :name, length: { is: 64 }
  validates :block_count, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 0
  }

  before_destroy :remove_data

  def data_root
    root = user.data_root.join(name)
    FileUtils.mkdir_p(root)
    root
  end

  def megs_used
    bytes = block_size * block_count
    bytes / (1024 * 1024)
  end

  def blocks
    list  = []

    Find.find(data_root.to_s) do |path|
      basename = Pathname.new(path).basename.to_s
      if FileTest.file?(path) && basename.size == 64
        list << basename
      end
    end

    if block_count != list.size
      self.block_count = list.size
      save!
    end
  
    list
  end

  def block_data(hash)
    Block.new(self, hash).data
  end

  private

  def remove_data
    return false unless data_root.to_s =~ /fogweb\/data/
    FileUtils.rm_rf(data_root)
  end
end
