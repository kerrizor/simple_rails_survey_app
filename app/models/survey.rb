class Survey < ApplicationRecord
  has_many :responses, dependent: :destroy

  validates :question, presence: true

  def response_count
    responses.count
  end

  def count_for(answer)
    validate_boolean!(answer)
    responses.where(answer: answer).count
  end

  def percentage_for(answer)
    validate_boolean!(answer)
    return nil if response_count.zero?

    (count_for(answer).to_f / response_count * 100).round(1)
  end

  private

  def validate_boolean!(answer)
    return if [ true, false ].include?(answer)

    raise ArgumentError, "answer must be true or false, got #{answer.inspect}"
  end
end
