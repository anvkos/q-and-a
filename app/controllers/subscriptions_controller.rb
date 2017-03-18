class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_subscription, only: [:destroy]

  authorize_resource

  respond_to :js

  def create
    @subscription = @question.subscriptions.new(user: current_user)
    authorize! :create, @subscription
    @subscription.save
    respond_with(@subscription)
  end

  def destroy
    @subscription.destroy
    respond_with(@subscription)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
