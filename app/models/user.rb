class User < ActiveRecord::Base
  has_many   :shares, dependent: :destroy
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

  def megs_used
    shares.reduce(0) {|mm, ss| mm + ss.megs_used }
  end

  def data_root
    Rails.root.join('data', id)
  end
end
