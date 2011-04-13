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
      subdomain.user.key = session[:key]
      subdomain.user.save
      session[:logged_key] = subdomain.user.key
      subdomain.is_confirmed = true
      subdomain.save
    else
      @user.key = Array.new(15) { (rand(122-97) + 97).chr }.join
      @user.save
    end
  end

  def update
    super
  end
end
