class MissionCheck < ApplicationRecord
  belongs_to :mission
  belongs_to :rocket_member
end
