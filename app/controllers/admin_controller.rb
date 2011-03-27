class AdminController < ApplicationController
  
  def index
    @user = current_user
    @subdomains = @user.subdomains
    @subdomain = @subdomains.first
    
    directory = "#{ASSETS_ROOT}/user_#{@subdomain.name}"
    @files = index_directory(directory, @subdomain.name)
  end
  
  def directory
    subdomain = params[:path].split('/').first.split('_').last
    redirect_to root_path unless check_ownership(subdomain)
    @parent = params[:path].split('/').last
    @parent_path = params[:path].sub("/#{@parent}", '')
    directory = "#{ASSETS_ROOT}/#{params[:path]}"
    @files = index_directory(directory, subdomain)
  end
  
  def index_directory(dir, subdomain)
    files = []
    Dir.foreach(dir) do |e|
      skip = false
      ['.', '..', '__MACOSX'].each{|test| skip = true if test == e}
      next if skip
      files << [File.directory?("#{dir}/#{e}"), e, "user_#{subdomain}/#{e}"]
    end
    files
  end
  
  def check_ownership(subdomain)
    Subdomain.where(:name => subdomain).last.key == current_user.key
  end
  
end
