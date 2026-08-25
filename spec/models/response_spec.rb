require "rails_helper"

RSpec.describe Response, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:survey) }
  end

  describe "validations" do
    subject(:response) { build(:response, survey: survey, answer: answer) }

    let(:survey) { build(:survey) }
    let(:answer) { true }

    context "with a survey and a true answer" do
      it { is_expected.to be_valid }
    end

    context "with a false answer" do
      let(:answer) { false }

      it { is_expected.to be_valid }
    end

    context "without an answer" do
      let(:answer) { nil }

      it { is_expected.not_to be_valid }
    end

    context "without a survey" do
      let(:survey) { nil }

      it { is_expected.not_to be_valid }
    end
  end
end
