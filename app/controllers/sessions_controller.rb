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
      return redirect_to request.env['omniauth.origin']
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
    return redirect_to request.env['omniauth.origin']
  end

  def destroy
    reset_session
    redirect_to request.referer
  end

  def logout
    reset_session
    redirect_to request.referer
  end
end
