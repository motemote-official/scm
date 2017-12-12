class RocketMember < ApplicationRecord
  belongs_to :rocket

  has_many :attends, dependent: :destroy

  has_many :mission_checks, dependent: :destroy
  has_many :missions, through: :mission_checks
end
