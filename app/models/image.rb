class Image < ApplicationRecord
  belongs_to :board

  mount_uploader :image, ImageUploader
end
