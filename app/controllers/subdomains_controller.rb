class SubdomainsController < ApplicationController
  
  def show
    @subdomain = Subdomain.find_by_subdomain(request.subdomain)
    redirect_to 'http://lvh.me:3000' and flash[:error] = "Durp, couldn't find a site with that name" unless @subdomain
    render :file => "david/index.html"
  end
end