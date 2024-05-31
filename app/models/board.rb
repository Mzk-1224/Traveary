class Board < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture

  mount_uploader :board_image, BoardImageUploader

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  paginates_per 20

end