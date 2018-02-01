class RocketPic < ApplicationRecord
  attr_accessor :user_name, :count_day

  mount_uploader :img, UploaderUploader

  belongs_to :rocket_regram
end
