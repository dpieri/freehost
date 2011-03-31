class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :ensure_domain
  
  
  def ensure_domain
    if request.env['HTTP_HOST'] == 'www.coralrift.com' || request.env['HTTP_HOST'] == 'http://coralrift.com' || request.env['HTTP_HOST'] == 'http://www.coralrift.com' || request.env['HTTP_HOST'] == 'coralrift.com' && Rails.env.production?
      # puts "redirecting because of #{request.env['HTTP_HOST']}, #{request.user_agent} "
      redirect_to "http://coralrift.com", :status => 301
      flash[:error] = "please don't use www"
    end  
  end
end
