class SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    super
    session[:logged_key] = current_user.key
    if session[:subdomain]
      subdomain = Subdomain.where(:name => session[:subdomain], :is_confirmed => false).first
      return unless subdomain
      subdomain.user = User.where(:email => params[:user][:email]).first
      subdomain.key = subdomain.user.key
      subdomain.is_confirmed = true
      subdomain.save
      # session[:subdomain] = nil
    end
  end

  def update
    super
  end
end
