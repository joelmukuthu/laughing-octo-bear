class HomeController < ApplicationController
  def index
    if current_user && current_user.email == User::TEMP_EMAIL && flash.none?
        @one_time_flash = {
          alert: 'Update your email address (your email address is currently set to a temporary address)'
        }
    end
  end
end
