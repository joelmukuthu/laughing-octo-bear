class UsersController < ApplicationController
  before_action :authenticate_user!

  # TODO: what if the email has already been used?
  # 1. check if the email has identities attached, ask user to sign in with one of them and 
  #    then attach their twitter to their account after successful sign in
  # 2. if no identities attached, ask them to sign in with the email or send a confirmation email
  def add_email
    if params[:user] && params[:user][:email]
      current_user.email = params[:user][:email]
      current_user.skip_reconfirmation! # don't forget this if using Devise confirmable
      respond_to do |format|
        if current_user.save
          # TODO: i18n this notice
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
