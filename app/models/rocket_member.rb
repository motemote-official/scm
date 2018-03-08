class RocketMember < ApplicationRecord
  enum pass: %w(fail hold pass)

  belongs_to :rocket

  has_many :attends, dependent: :destroy

  has_many :mission_checks, dependent: :destroy
  has_many :missions, through: :mission_checks

  scope :hold, -> {where(pass: 'hold')}
  scope :pass, -> {where(pass: 'pass')}
end
