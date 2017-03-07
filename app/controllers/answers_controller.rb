class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :mark_best, :destroy]
  before_action :set_answer, only: [:update, :mark_best, :destroy]
  before_action :set_question, only: [:create]

  after_action :publish_answer, only: [:create]

  authorize_resource

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def mark_best
    @answer.mark_best if current_user.author?(@answer.question)
    respond_with(@answer)
  end

  def destroy
    @answer.destroy
    respond_with(@answer)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "question_#{@question.id}_answers",
      answer: @answer,
      question_author: @answer.question.user.id,
      attachments: @answer.attachments.map { |a| { id: a.id, file_name: a.file.identifier, file_url: a.file.url } }
    )
  end
end
