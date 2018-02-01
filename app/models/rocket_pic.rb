class RocketPic < ApplicationRecord
  attr_accessor :user_name, :count_day, :start_date

  mount_uploader :img, UploaderUploader

  belongs_to :rocket_regram
end
