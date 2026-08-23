require "test_helper"

class SurveyTest < ActiveSupport::TestCase
  test "is valid with a question" do
    survey = Survey.new(question: "Is Ruby dead?")
    assert survey.valid?
  end

  test "is invalid without a question" do
    survey = Survey.new(question: nil)
    assert_not survey.valid?
  end
end
