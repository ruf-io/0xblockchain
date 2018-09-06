class LoginBannedError < StandardError; end
class LoginDeletedError < StandardError; end
class LoginTOTPFailedError < StandardError; end
class LoginFailedError < StandardError; end

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    fail_reason = nil

    begin
      if !user.valid?
        raise LoginFailedError
      end

      if user.is_banned?
        raise LoginBannedError
      end

      if !user.is_active?
        raise LoginDeletedError
      end

      session[:u] = user.session_token
      origin_url = request.env['omniauth.origin'] || "/"
      return redirect_to origin_url
    rescue LoginBannedError
      fail_reason = "Your account has been banned."
    rescue LoginDeletedError
      fail_reason = "Your account has been deleted."
    rescue LoginTOTPFailedError
      fail_reason = "Your TOTP code was invalid."
    rescue LoginFailedError
      fail_reason = "Invalid e-mail address and/or password."
    end

    # Return to the pervious page with error message
    flash.now[:error] = fail_reason
    @referer = params[:referer]
    origin_url = request.env['omniauth.origin'] || "/"
    return redirect_to origin_url
  end

  def destroy
    reset_session
    flash[:success] = "You have successfully logged out!"
    redirect_to root_path
  end

  def logout
    reset_session
    flash[:success] = "You have successfully logged out!"
    redirect_to root_path
  end
end
