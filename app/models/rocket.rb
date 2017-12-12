class Rocket < ApplicationRecord
  has_many :rocket_members

  has_many :rocket_regrams

  has_many :missions
end
