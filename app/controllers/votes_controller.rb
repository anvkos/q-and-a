class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable!, only: [:create]

  def create
    @vote = @votable.votes.build(vote_params)
    @vote.user = current_user
    if @vote.save
      render_success(@vote, 'create', 'Your vote has been accepted!')
    else
      render_error('Error save', 'Not the correct vote data!')
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

  def render_error(error = 'error', message = 'message')
    render json: { error: error, error_message: message }, status: :unprocessable_entity
  end

  def set_votable!
    votable_id = params["#{params[:votable_type].underscore}_id"]
    @votable = params[:votable_type].constantize.find(votable_id)
  rescue NoMethodError, NameError => e
    render_error('Error save', 'Not the correct vote data!')
  end

  def vote_params
    { rating: params[:rating] == 'up' ? 1 : -1 }
  end
end
