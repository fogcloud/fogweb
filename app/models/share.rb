class Share < ActiveRecord::Base
  belongs_to :user

  validates :name, length: { is: 64 }
  validates :blocks, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 0
  }

  before_destroy :remove_data

  def data_root
    user.data_root.join(name)
  end

  def megs_used
    bytes = Block.block_size * ss.blocks
    bytes / (1024 * 1024)
  end

  private

  def remove_data
    return false unless data_root =~ /fogweb\/data/
    FileUtils.rm_r(data_root)
  end
end
