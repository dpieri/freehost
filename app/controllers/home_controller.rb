class HomeController < ApplicationController
  def subdomain
  end
  
  def show
    @subdomain = Subdomain.new
  end

  def about
  end

end
