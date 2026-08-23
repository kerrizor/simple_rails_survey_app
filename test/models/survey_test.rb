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

  test "has many responses" do
    survey = surveys(:ruby_dead)
    assert_equal 2, survey.responses.count
  end

  test "destroys its responses when destroyed" do
    survey = surveys(:ruby_dead)
    assert_difference -> { Response.count }, -2 do
      survey.destroy
    end
  end
end
