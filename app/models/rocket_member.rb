class RocketMember < ApplicationRecord
  belongs_to :rocket

  has_many :attends, dependent: :destroy
end
