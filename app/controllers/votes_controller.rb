class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable!, only: [:create]

  def create
    if !current_user.author?(@votable) && @votable.vote_user(current_user).nil?
      @vote = @votable.send("vote_#{vote_params[:rating]}", current_user)
      if @vote.persisted?
        render_success(@vote, 'create', 'Your vote has been accepted!')
      else
        render_error(:unprocessable_entity, 'Error save', 'Not the correct vote data!')
      end
    else
      render_error(:forbidden, 'Error save', 'You can not vote')
    end
  end

  def destroy
    vote = Vote.find(params[:id])
    if current_user.author?(vote)
      vote.destroy
      render_success(vote, 'delete', 'Your vote removed!')
    else
      render_error(:forbidden, 'Error remove', 'You can not remove an vote!')
    end
  end

  private

  def render_success(item, action, message)
    render json: item.slice(:id, :votable_id)
                      .merge(
                        votable_type: item.votable_type.underscore,
                        votable_rating: item.votable.rating,
                        action: action,
                        message: message
                      )
  end

  def render_error(status, error = 'error', message = 'message')
    render json: { error: error, error_message: message }, status: status
  end

  def set_votable!
    votable_id = params["#{params[:votable_type].underscore}_id"]
    @votable = params[:votable_type].constantize.find(votable_id)
  rescue NoMethodError, NameError
    render_error(:bad_request, 'Error', 'Not the correct vote data!')
  end

  def vote_params
    { rating: params[:rating] == 'up' ? :up : :down }
  end
end
