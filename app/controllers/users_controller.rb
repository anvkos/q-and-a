class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def confirmation_email
    @user = User.find_by!(confirmation_token: params[:token])
    if User.find_by(user_params) && user_params[:email] != @user.email
      @user.errors.add(:email, ' already in use!')
    else
      @user.update!(user_params)
      @user.send_reconfirmation_instructions
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def record_invalid
    render :confirmation_email, status: :unprocessable_entity
  end
end
