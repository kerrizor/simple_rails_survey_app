require "rails_helper"

RSpec.describe Survey, type: :model do
  subject(:survey) { create(:survey) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:question) }
  end

  describe "associations" do
    it { is_expected.to have_many(:responses).dependent(:destroy) }
  end

  describe "#response_count" do
    it "returns the number of responses" do
      create_list(:response, 2, survey: survey)

      expect(survey.response_count).to eq(2)
    end
  end

  describe "#count_for" do
    before do
      create(:response, survey: survey, answer: true)
      create(:response, survey: survey, answer: false)
    end

    it "counts responses matching the given boolean" do
      expect(survey.count_for(true)).to eq(1)
      expect(survey.count_for(false)).to eq(1)
    end

    it "raises on a non-boolean answer" do
      expect { survey.count_for(:true) }.to raise_error(ArgumentError)
    end
  end

  describe "#percentage_for" do
    context "with no responses" do
      it "returns nil" do
        expect(survey.percentage_for(true)).to be_nil
        expect(survey.percentage_for(false)).to be_nil
      end
    end

    context "with an even split" do
      before do
        create(:response, survey: survey, answer: true)
        create(:response, survey: survey, answer: false)
      end

      it "calculates to one decimal place" do
        expect(survey.percentage_for(true)).to eq(50.0)
        expect(survey.percentage_for(false)).to eq(50.0)
      end
    end

    context "with an uneven split" do
      before do
        create_list(:response, 2, survey: survey, answer: true)
        create(:response, survey: survey, answer: false)
      end

      it "rounds to one decimal place" do
        expect(survey.percentage_for(true)).to eq(66.7)
      end
    end

    context "with a non-boolean answer" do
      it "raises an ArgumentError" do
        expect { survey.percentage_for("yes") }.to raise_error(ArgumentError)
        expect { survey.percentage_for(nil) }.to raise_error(ArgumentError)
      end
    end
  end
end
