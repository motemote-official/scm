class Regram < ApplicationRecord
  mount_uploader :img, UploaderUploader

  belongs_to :member, counter_cache: true

  belongs_to :timepool
end
