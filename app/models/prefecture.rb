class Prefecture < ApplicationRecord
  has_many :boards
  has_many :users, through: :board

  validates :name, presence: true
end
