class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :detect_browser
  # before_filter :init_web_thumb
  # require 'rwebthumb'
  # require 'digest/md5'
  # include Simplificator::Webthumb
  
  def after_sign_in_path_for(resource)
    "/admin"
  end
  
  def init_web_thumb
    # wt = Webthumb.new('f48f1f5fc910564a8f03a03bd455536c')

    # Create a new thumbnail job
    # job = wt.thumbnail(:url => 'http://cmu.edu')
    # fetch the thumbnail. this might throw an exception from server side
    # if thumb is not ready yet
    # job.fetch(:large)
    # job.write_file(job.fetch(:large), '/tmp/test.jpg')
    
    # et = Easythumb.new('f48f1f5fc910564a8f03a03bd455536c', '11144')
    # This returns an URL which you can directly use in your webpage
    # puts et.build_url(:url => 'http://cmu.edu', :size => :large, :cache => 1)
    date = Time.now.strftime("%Y%m%d")
    puts date
    url = "http://cmu.edu"
    key = 'f48f1f5fc910564a8f03a03bd455536c'
    puts "#{date}#{url}#{key}"
    
    
    hash = Digest::MD5.hexdigest("#{date}#{url}#{key}")
    puts hash
    # puts "http://webthumb.bluga.net/easythumb.php?user=11144&url=cmu.edu&size=medium&cache=1&hash=#{hash}"
    puts "http://webthumb.bluga.net/easythumb.php?url=http%3A%2F%2Fcmu.edu%2F&cache=5&hash=#{hash}&user=11144&size=large"
  end
  
  def detect_browser
    @is_shitty_browser = users_browser
  end
  
  def users_browser
  user_agent =  request.env['HTTP_USER_AGENT'].downcase 
  @users_browser ||= begin
    if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
          true
      elsif user_agent.index('gecko/')
          true
      elsif user_agent.index('opera')
          false
      elsif user_agent.index('konqueror')
          'konqueror'
      elsif user_agent.index('ipod')
          false
      elsif user_agent.index('ipad')
          false
      elsif user_agent.index('iphone')
          false
      elsif user_agent.index('chrome/')
          false
      elsif user_agent.index('applewebkit/')
          false
      elsif user_agent.index('googlebot/')
          false
      elsif user_agent.index('msnbot')
          false
      elsif user_agent.index('yahoo! slurp')
          false
      #Everything thinks it's mozilla, so this goes last
      elsif user_agent.index('mozilla/')
          true
      else
          true
      end
      end

      return @users_browser
  end
end
