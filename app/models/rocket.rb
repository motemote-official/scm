class Rocket < ApplicationRecord
  has_many :rocket_members, dependent: :destroy

  has_many :rocket_regrams, dependent: :destroy

  has_many :missions, dependent: :destroy
end
