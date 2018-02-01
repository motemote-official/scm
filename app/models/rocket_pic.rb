class RocketPic < ApplicationRecord
  attr_accessor :start_date

  mount_uploader :img, UploaderUploader

  belongs_to :rocket_regram
end
