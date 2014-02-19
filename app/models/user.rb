class User < ActiveRecord::Base
  has_many   :blocks, dependent: :destroy
  belongs_to :plan

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  def plan
    if plan_id.nil?
      Plan.first
    else
      Plan.find(plan_id)
    end
  end

  def megs
    (blocks.count * Block.block_size) / 1.megabyte
  end
end
