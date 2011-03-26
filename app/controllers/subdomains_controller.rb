class SubdomainsController < ApplicationController
  
  def show
    # @subdomain = Subdomain.find_by_subdomain(request.subdomain)
    # redirect_to 'http://lvh.me:3000' and flash[:error] = "Durp, couldn't find a site with that name" unless @subdomain
    # render :file => "/index.html"
  end
  
  def create
    if Subdomain.exists?(:name => params[:subdomain][:name])
      flash[:error] = "Sorry, somebody already has that subdomain"
      redirect_to root_path
      return
    end
    
    sub = Subdomain.new
    sub.name = params[:subdomain][:name]
    sub.is_confirmed = false
    uploaded_io = params[:zip]
    directory = "/www/freehost/assets/user_#{sub.name}"
    Dir.mkdir directory unless File.directory?(directory)
    name = uploaded_io.original_filename
    path = File.join(directory, name)
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    Subdomain.unzip(path, directory) ? flash[:notice] = "All good" : flash[:error] = "Error unzipping your file"
    Subdomain.move_up(directory, name)
    sub.save ? flash[:notice] = "Website uploaded!" : flash[:error] = "Oops! Something wen't wrong. Please try again"
    redirect_to root_path
  end
end