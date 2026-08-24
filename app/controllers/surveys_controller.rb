class SurveysController < ApplicationController
  def index
    @surveys = Survey.all
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      redirect_to root_path, notice: "Survey created."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:question)
  end
end
