class RocketPic < ApplicationRecord
  mount_uploader :img, UploaderUploader

  belongs_to :rocket_regram
end
