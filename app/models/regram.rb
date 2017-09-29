class Regram < ApplicationRecord
  mount_uploader :img, UploaderUploader

  belongs_to :member

  belongs_to :timepool
end
