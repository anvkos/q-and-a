class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    respond_with(@questions, each_serializer: QuestionSerializer)
  end
end
