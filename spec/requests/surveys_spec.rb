require "rails_helper"

RSpec.describe "Surveys", type: :request do
  describe "GET /" do
    before { get root_path }

    it "responds successfully" do
      expect(response).to have_http_status(:success)
    end

    it "links to the new survey form" do
      assert_select "a[href=?]", new_survey_path, text: /New Survey/
    end

    context "with a survey that has responses" do
      let(:survey) { create(:survey, question: "Is Ruby dead?") }

      before do
        create(:response, survey: survey, answer: true)
        create(:response, survey: survey, answer: false)
        get root_path
      end

      it "lists the survey by question" do
        expect(response.body).to include("Is Ruby dead?")
      end

      it "shows result percentages" do
        expect(response.body).to include("50.0")
      end
    end

    context "with a survey that has no responses" do
      before do
        create(:survey)
        get root_path
      end

      it "shows 'No responses yet'" do
        expect(response.body).to include("No responses yet")
      end
    end
  end

  describe "GET /surveys/new" do
    before { get new_survey_path }

    it "renders the form" do
      expect(response).to have_http_status(:success)
      assert_select "form"
    end
  end

  describe "POST /surveys" do
    subject(:submit) { post surveys_path, params: { survey: { question: question } } }

    context "with valid params" do
      let(:question) { "New question?" }

      it "saves a survey" do
        expect { submit }.to change(Survey, :count).by(1)
      end

      it "redirects home with a notice" do
        submit

        expect(response).to redirect_to(root_path)
        follow_redirect!
        assert_select "[data-flash=notice]", text: /Survey created/
      end
    end

    context "with invalid params" do
      let(:question) { "" }

      it "does not save a survey" do
        expect { submit }.not_to change(Survey, :count)
      end

      it "re-renders the form with an error" do
        submit

        expect(response).to have_http_status(:unprocessable_content)
        assert_select "[role=alert]", text: /couldn't be saved/
        assert_select "[role=alert] li", text: /Question can't be blank/
      end
    end
  end
end
