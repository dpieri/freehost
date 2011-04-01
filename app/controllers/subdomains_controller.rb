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
    
    unless params[:zip]
      flash[:error] = "Please choose a zip file to upload first"
      redirect_to root_path
      return
    end
    
    sub = Subdomain.new
    sub.name = params[:subdomain][:name]
    sub.is_confirmed = false
    sub.key = "monkey"
    uploaded_io = params[:zip]
    directory = "/home/coralrift/assets/user_#{sub.name}"
    Dir.mkdir directory unless File.directory?(directory)
    name = uploaded_io.original_filename
    path = File.join(directory, name)
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    Subdomain.unzip(path, directory) ? flash[:notice] = "All good" : flash[:error] = "Error unzipping your file"
    Subdomain.move_up(directory, name)
    if sub.save 
      flash[:notice] = "Website uploaded!"
      session[:subdomain] = "#{sub.name}"
      redirect_to "/welcome"
    else 
      flash[:error] = "Oops! Something wen't wrong. Please try again"
      redirect_to "/admin"
    end
  end
  
  def index
    @subdomain = Subdomain.where(:name => session[:subdomain], :is_confirmed => false).first
    redirect_to root_path and return unless @subdomain
    
    #signup for stuff
    @user = User.new
    @user_resource_name = :user
    
    #list the files
    directory = "#{ASSETS_ROOT}/user_#{@subdomain.name}"
    @files = []
    Dir.foreach(directory) do |e|
      skip = false
      ['.', '..', '__MACOSX'].each{|test| skip = true if test == e}
      next if skip
      @files << [File.directory?("#{directory}/#{e}"), e]
    end
  end
end