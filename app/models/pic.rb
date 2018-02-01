class Pic < ApplicationRecord
  extend CarrierWave::Mount

  attr_accessor :user_name, :count_day

  mount_uploader :img, UploaderUploader

  belongs_to :regram
end
