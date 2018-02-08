class FbPic < ApplicationRecord
  attr_accessor :count_day

  mount_uploader :img, UploaderUploader

  belongs_to :facebook
end
