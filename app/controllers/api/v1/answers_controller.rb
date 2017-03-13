class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]
  before_action :set_answer, only: [:show]

  authorize_resource

  def index
    @answers = @question.answers
    respond_with(@answers, each_serializer: AnswersSerializer)
  end

  def show
    respond_with(@answer)
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id))
    respond_with(@answer)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
