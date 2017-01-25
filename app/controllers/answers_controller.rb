class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_question, only: [:create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      flash[:alert] = "Not the correct answer data!"
      render 'questions/show'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
