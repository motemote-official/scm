class Pic < ApplicationRecord
  extend CarrierWave::Mount

  attr_accessor :user_name

  mount_uploader :img, UploaderUploader

  belongs_to :regram
end
