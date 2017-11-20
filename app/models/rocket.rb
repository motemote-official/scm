class Rocket < ApplicationRecord
  has_many :rocket_members

  has_many :rocket_regrams
end
