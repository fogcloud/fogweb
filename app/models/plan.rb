class Plan < ActiveRecord::Base
  has_many :users, dependent: :restrict
end
