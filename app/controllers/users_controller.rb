class UsersController < ApplicationController
  before_action :authenticate_user!

  def add_email
    if params[:user] && params[:user][:email]
      current_user.email = params[:user][:email]
      current_user.skip_reconfirmation! # don't forget this if using Devise confirmable
      respond_to do |format|
        if current_user.save
          format.html { redirect_to current_user, notice: 'Your email address was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { }
          format.json { render json: current_user.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
end
