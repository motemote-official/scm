class Mission < ApplicationRecord
  has_many :mission_checks, dependent: :destroy
  has_many :missions, through: :mission_checks

  belongs_to :rocket
end
