require 'securerandom'

class User < ActiveRecord::Base
  has_many   :shares, dependent: :destroy
  belongs_to :plan

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :generate_auth_key

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

  def megs_trans
    bytes = shares.reduce(0) {|bb, ss| bb + ss.trans_bytes }
    bytes / (1024 * 1024)
  end

  def data_root
    Rails.root.join('data', Rails.env, "#{id}")
  end

  private

  def generate_auth_key
    if auth_key.nil? || auth_key.size != 32
      auth_key = SecureRandom.hex(16)
    end
  end
end
