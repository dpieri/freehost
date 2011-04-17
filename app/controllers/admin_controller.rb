class AdminController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @user = current_user
    @subdomains = @user.subdomains
    if params[:subdomain]
      @subdomain = @user.subdomains.where(:name => params[:subdomain]).first
      redirect_to "/admin" and return unless @subdomain && @subdomain.key == session[:logged_key]
    else
      @subdomain = @subdomains.first
    end

    @new_subdomain = Subdomain.new
    #return if they don't have any subdomains
    @show_preview = false
    @has_index = true
    return if @subdomain.nil?
    
    directory = "#{ASSETS_ROOT}/user_#{@subdomain.name}"
    @files = index_directory(@subdomain.name, "")
  end
  
  def directory
    @subdomain = current_user.subdomains.where(:name => params[:subdomain]).first
    redirect_to root_path and puts "no match on directory" and return unless @subdomain && @subdomain.key == session[:logged_key]
    @this_dir = params[:path].split('/').last
    @parent_path = params[:path].sub("/#{@this_dir}", '')
    # directory = "#{ASSETS_ROOT}#{params[:path]}"
    @files = index_directory(@subdomain.name, params[:path])
    render :partial => 'admin/files/file_list',:locals => {:files => @files}
  end
  
  def index_directory(subdomain, rel_dir)
    files = []
    absolute_path = "#{ASSETS_ROOT}/user_#{subdomain}/#{rel_dir}"
    Dir.mkdir absolute_path unless File.directory?(absolute_path)
    no_files = true
    has_index = false
    Dir.foreach(absolute_path) do |e|
      skip = false
      ['.', '..', '__MACOSX'].each{|test| skip = true if test == e}
      next if skip
      no_files = false
      has_index = true if e == 'index.html' || e == 'index.htm'
      files << [File.directory?("#{absolute_path}/#{e}"), e, "#{rel_dir}/#{e}" ]
    end
    @has_index = has_index || no_files  #only give warning if there are files but no index.html
    @show_preview = has_index
    files
  end
  
  def delete_file
    @subdomain = current_user.subdomains.where(:name => params[:subdomain]).first
    redirect_to root_path and return unless @subdomain  && @subdomain.key == session[:logged_key]
    #delete the file
    file = "#{ASSETS_ROOT}/user_#{@subdomain.name}#{params[:path]}"
    File.delete(file) if File.exists?(file)
    
    #and re-index for js returned
    @the_file = params[:path].split('/').last
    this_dir_path = params[:path].sub("/#{@the_file}", '')
    @this_dir = this_dir_path.split('/').last
    @parent_path = this_dir_path.sub("/#{@this_dir}", '')
    @files = index_directory(@subdomain.name, this_dir_path)
    # render :partial => 'admin/files/file_list',:locals => {:files => @files}
  end
  
  def delete_subdomain
    subdomain = current_user.subdomains.where(:name => params[:subdomain]).first
    redirect_to root_path and return unless subdomain  && subdomain.key == session[:logged_key]
    time = Time.now.to_i.to_s
    directory = FileUtils.mkdir_p("#{ASSETS_ROOT}/backups/#{time}_#{subdomain.name}")
    FileUtils.cp_r "#{ASSETS_ROOT}/user_#{subdomain.name}" , directory
    FileUtils.rm_rf("#{ASSETS_ROOT}/user_#{subdomain.name}")
    subdomain.delete
    redirect_to "/admin"
  end
  
  def check_ownership(subdomain)
    Subdomain.where(:name => subdomain).last.key == current_user.key
  end
  
end
