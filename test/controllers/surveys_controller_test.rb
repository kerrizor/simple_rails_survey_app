require "test_helper"

class SurveysControllerTest < ActionDispatch::IntegrationTest
  # Shared for the tests that just need the home screen rendered as-is.
  setup do
    get root_path
  end

  test "index responds successfully" do
    assert_response :success
  end

  test "index lists surveys by question" do
    assert_select "body", text: /Is Ruby dead\?/   # fixture question appears
  end

  test "index shows result percentages for a survey with responses" do
    # ruby_dead has 1 true + 1 false → 50.0% each
    assert_select "body", text: /50\.0/
  end

  test "index has a link to create a new survey" do
    assert_select "a[href=?]", new_survey_path, text: /New Survey/
  end

  # Fun with minitest... This test can't rely solely on the shared setup: it
  # must create the survey BEFORE fetching the page, so it re-issues its own get
  # root_path after the create. The setup's get root_path is therefore
  # duplicated effort here, but keeping the shared setup keeps the other four
  # tests DRY.
  #
  test "index shows 'No responses yet' for a survey without responses" do
    Survey.create!(question: "Brand new survey?")
    get root_path

    assert_select "body", text: /No responses yet/
  end

  # new / create
  #
  test "new renders the form" do
    get new_survey_path

    assert_response :success
    assert_select "form"
  end

  test "create saves a survey and redirects home" do
    assert_difference -> { Survey.count }, 1 do
      post surveys_path, params: { survey: { question: "New question?" } }
    end

    assert_redirected_to root_path

    follow_redirect!
    assert_select "[data-flash=notice]", text: /Survey created/
  end

  test "create re-renders new when invalid" do
    assert_no_difference -> { Survey.count } do
      post surveys_path, params: { survey: { question: "" } }
    end

    assert_response :unprocessable_content
    assert_select "[role=alert]", text: /couldn't be saved/
    assert_select "[role=alert] li", text: /Question can't be blank/
  end
end
