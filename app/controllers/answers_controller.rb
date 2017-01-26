class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      flash[:alert] = "Not the correct answer data!"
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully destroyed.'
      redirect_to @answer.question
    else
      flash[:alert] = 'You can not remove an answer!'
      @question = @answer.question
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
