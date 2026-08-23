require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "is valid with a survey and a true answer" do
    response = Response.new(survey: surveys(:ruby_dead), answer: true)
    assert response.valid?
  end

  test "is valid with a false answer" do
    response = Response.new(survey: surveys(:ruby_dead), answer: false)
    assert response.valid?
  end

  test "is invalid without an answer" do
    response = Response.new(survey: surveys(:ruby_dead), answer: nil)
    assert_not response.valid?
  end

  test "is invalid without a survey" do
    response = Response.new(survey: nil, answer: true)
    assert_not response.valid?
  end
end
