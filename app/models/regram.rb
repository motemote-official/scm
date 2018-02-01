class Regram < ApplicationRecord
  attr_accessor :user_email_test

  belongs_to :member

  belongs_to :timepool

  has_many :pics, dependent: :destroy
  accepts_nested_attributes_for :pics, allow_destroy: true

  mount_uploader :img, UploaderUploader
end
