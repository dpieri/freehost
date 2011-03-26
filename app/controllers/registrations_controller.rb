class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
    if session[:subdomain]
      subdomain = Subdomain.where(:name => session[:subdomain], :is_confirmed => false).first
      return unless subdomain
      subdomain.user = User.where(:email => params[:user][:email]).first
      subdomain.is_confirmed = true
      subdomain.save
    end
  end

  def update
    super
  end
end
