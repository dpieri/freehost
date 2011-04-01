class AdminController < ApplicationController
  
  def index
    @user = current_user
    @subdomains = @user.subdomains
    if params[:subdomain]
      @subdomain = @user.subdomains.where(:name => params[:subdomain]).first
      redirect_to "/admin" and return unless @subdomain
    else
      @subdomain = @subdomains.first
    end
    
    @new_subdomain = Subdomain.new
    directory = "#{ASSETS_ROOT}/user_#{@subdomain.name}"
    @files = index_directory(directory, @subdomain.name, "")
  end
  
  def directory
    @subdomain = current_user.subdomains.where(:name => params[:subdomain]).first
    redirect_to root_path and return unless @subdomain
    #redirect_to root_path unless check_ownership(subdomain) #redundant maybe?
    @this_dir = params[:path].split('/').last
    @parent_path = params[:path].sub("/#{@this_dir}", '')
    directory = "#{ASSETS_ROOT}#{params[:path]}"
    @files = index_directory(directory, @subdomain.name, params[:path])
    render :partial => 'admin/files/file_list',:locals => {:files => @files}
  end
  
  def index_directory(dir, subdomain, rel_dir)
    files = []
    absolute_path = "#{ASSETS_ROOT}/user_#{subdomain}/#{rel_dir}"
    Dir.foreach(absolute_path) do |e|
      skip = false
      ['.', '..', '__MACOSX'].each{|test| skip = true if test == e}
      next if skip
      files << [File.directory?("#{absolute_path}/#{e}"), e, "#{rel_dir}/#{e}" ]
    end
    files
  end
  
  def delete_file
    subdomain = current_user.subdomains.where(:name => params[:subdomain]).first
    redirect_to root_path and return unless subdomain
    #delete the file
    file = "#{ASSETS_ROOT}/user_#{subdomain.name}#{params[:path]}"
    File.delete(file) if File.exists?(file)
    
    #and re-index for js returned
    @the_file = params[:path].split('/').last
    @this_dir = params[:path].sub("/#{@the_file}", '')
    directory = "#{ASSETS_ROOT}#{@this_dir}"
    @files = index_directory(directory, @subdomain.name, params[:path])
    render :partial => 'admin/files/file_list',:locals => {:files => @files}
  end
  
  def check_ownership(subdomain)
    Subdomain.where(:name => subdomain).last.key == current_user.key
  end
  
end
