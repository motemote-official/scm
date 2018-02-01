class Pic < ApplicationRecord
  extend CarrierWave::Mount

  mount_uploader :img, UploaderUploader

  belongs_to :regram
end
