class VotesController < ApplicationController
  include Polymorphic
  include Serialized

  before_action :authenticate_user!
  before_action :set_parent!, only: [:create]
  before_action :set_vote, only: [:destroy]

  authorize_resource

  def create
    if !current_user.author?(@parent) && @parent.vote_user(current_user).nil?
      @vote = @parent.send("vote_#{vote_params[:rating]}", current_user)
      if @vote.persisted?
        render_success(prepare_data(@vote), 'create', 'Your vote has been accepted!')
      else
        render_error(:unprocessable_entity, 'Error save', 'Not the correct vote data!')
      end
    else
      render_error(:forbidden, 'Error save', 'You can not vote')
    end
  end

  def destroy
    @vote.destroy
    render_success(prepare_data(@vote), 'delete', 'Your vote removed!')
  end

  private

  def set_vote
    @vote = Vote.find(params[:id])
  end

  def prepare_data(item)
    item.slice(:id, :votable_id)
        .merge(
          votable_type: item.votable_type.underscore,
          votable_rating: item.votable.rating
        )
  end

  def vote_params
    { rating: params[:rating] == 'up' ? :up : :down }
  end
end
