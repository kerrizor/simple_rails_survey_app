require "test_helper"

class SurveyTest < ActiveSupport::TestCase
  # Validations
  #
  test "is valid with a question" do
    survey = Survey.new(question: "Is Ruby dead?")
    assert survey.valid?
  end

  test "is invalid without a question" do
    survey = Survey.new(question: nil)
    assert_not survey.valid?
  end

  # Relationships
  #
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

  # Percentage calculations
  #
  # The model speaks true/false; the yes/no meaning is applied by the UI.
  test "percentage_for(true) returns nil with no responses" do
    survey = Survey.create!(question: "Empty survey?")
    assert_nil survey.percentage_for(true)
  end

  test "percentage_for(false) returns nil with no responses" do
    survey = Survey.create!(question: "Empty survey?")
    assert_nil survey.percentage_for(false)
  end

  test "percentage_for(true) calculates to one decimal place" do
    assert_equal 50.0, surveys(:ruby_dead).percentage_for(true)
  end

  test "percentage_for(false) calculates to one decimal place" do
    assert_equal 50.0, surveys(:ruby_dead).percentage_for(false)
  end

  test "percentage_for rounds to one decimal" do
    survey = Survey.create!(question: "Two thirds?")

    survey.responses.create!(answer: true)
    survey.responses.create!(answer: true)
    survey.responses.create!(answer: false)

    assert_equal 66.7, survey.percentage_for(true)
  end

  test "count_for returns the number of matching responses" do
    survey = surveys(:ruby_dead)
    assert_equal 1, survey.count_for(true)
    assert_equal 1, survey.count_for(false)
  end

  test "percentage_for raises on a non-boolean answer" do
    assert_raises(ArgumentError) { surveys(:ruby_dead).percentage_for("yes") }
    assert_raises(ArgumentError) { surveys(:ruby_dead).percentage_for(nil) }
  end

  test "count_for raises on a non-boolean answer" do
    assert_raises(ArgumentError) { surveys(:ruby_dead).count_for(:true) }
  end
end
