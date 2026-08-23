class Survey < ApplicationRecord
  has_many :responses, dependent: :destroy

  validates :question, presence: true
end
