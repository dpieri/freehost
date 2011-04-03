class SubdomainsController < ApplicationController
  # before_filter :authenticate_user!, :except => [:reupload, :index, :uploader]
  
  def show
    # @subdomain = Subdomain.find_by_subdomain(request.subdomain)
    # redirect_to 'http://lvh.me:3000' and flash[:error] = "Durp, couldn't find a site with that name" unless @subdomain
    # render :file => "/index.html"
  end
  
  def create
    if params[:subdomain][:name].match(/\s/)
      flash[:error] = "Please choose a subdomain name without spaces"
      redirect_to root_path
      return
    end
    
    if params[:no_zip] == "true"
      #DRY!
      if Subdomain.exists?(:name => params[:subdomain][:name])
        flash[:error] = "Sorry, somebody already has that subdomain"
        redirect_to "/admin"
        return
      end
      
      sub = Subdomain.new
      sub.name = params[:subdomain][:name]
      sub.is_confirmed = true
      sub.user = current_user
      sub.key = current_user.key
      
      directory = "#{ASSETS_ROOT}/user_#{sub.name}"
      Dir.mkdir directory unless File.directory?(directory)
      
      if sub.save 
        flash[:notice] = "Subdomain Claimed"
        redirect_to "/admin"
      else 
        flash[:error] = "Oops! Something wen't wrong. Please try again"
        redirect_to "/admin"
      end
      return
    end
    
    if Subdomain.exists?(:name => params[:subdomain][:name])
      flash[:error] = "Sorry, somebody already has that subdomain"
      redirect_to root_path
      return
    end
    
    sub = Subdomain.new
    sub.name = params[:subdomain][:name]
    sub.is_confirmed = false
    sub.key = (size = 25; (0..size).inject('') { |r, i| r << rand(93) + 33 })
    session[:key] = sub.key
    
    Subdomain.unzip(sub.name, params[:temp_file]) ? flash[:notice] = "zip uploaded and unzipped" : flash[:error] = "Error unzipping your file"
    Subdomain.move_up(sub.name)
    
    if sub.save 
      flash[:notice] = "Website uploaded!"
      session[:subdomain] = "#{sub.name}"
      redirect_to "/welcome"
    else 
      flash[:error] = "Oops! Something wen't wrong. Please try again"
      redirect_to root_path
    end
  end
  
  def uploader
    random_string = Time.now.to_i.to_s
    @temp_file = random_string + params[:qqfile].gsub(/ /,'')
    upload_zip params[:file], random_string
    return true
  end
  
  def reupload
    subdomain = Subdomain.where(:name => params[:subdomain]).first
    return if subdomain.key != params[:key]
    #it's a zip
    if (params[:qqfile] =~ /.*(zip)$/)
      random_string = Time.now.to_i.to_s
      @temp_file = random_string + params[:qqfile].gsub(/ /,'').gsub('%20', '')
      upload_zip params[:file], random_string
      Subdomain.unzip(subdomain.name, @temp_file) ? flash[:notice] = "zip uploaded and unzipped"  : flash[:error] = "Error unzipping your file"
      Subdomain.move_up(subdomain.name)
    elsif (params[:qqfile] =~ /.*(php|rb|exe)$/)
      
    else
      upload_file params[:file], params[:path], subdomain.name
    end
  end
  
  def upload_zip(file, random_string)
    uploaded_io = file
    directory = "#{ASSETS_ROOT}/uploads"     #"#{ASSETS_ROOT}/user_#{sub.name}"
    # Dir.mkdir directory unless File.directory?(directory)
    name = random_string  + uploaded_io.original_filename.gsub(/ /,'').gsub('%20', '')
    path = File.join(directory, name)
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end
  
  def upload_file(file, path, subdomain)
    uploaded_io = file
    directory = "#{ASSETS_ROOT}/user_#{subdomain}#{path}"
    # Dir.mkdir directory unless File.directory?(directory)
    name = uploaded_io.original_filename.gsub(/ /,'').gsub('%20', '')
    path = File.join(directory, name)
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
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