class Board < ApplicationRecord
  belongs_to :user
  has_many :images, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  accepts_nested_attributes_for :images, allow_destroy: true

  paginates_per 20

end