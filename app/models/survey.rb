class Survey < ApplicationRecord
  validates :question, presence: true
end
