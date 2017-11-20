class Pic < ApplicationRecord
  mount_uploader :img, UploaderUploader

  belongs_to :regram
end
