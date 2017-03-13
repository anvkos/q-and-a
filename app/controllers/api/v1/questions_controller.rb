class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show]

  def index
    @questions = Question.all
    respond_with(@questions, each_serializer: QuestionsSerializer)
  end

  def show
    respond_with(@question)
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    respond_with(@question)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
