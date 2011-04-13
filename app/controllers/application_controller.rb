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
  
  def detect_browser
    @is_shitty_browser = users_browser
  end
  
  def users_browser
  return  false unless request.env['HTTP_USER_AGENT']
  user_agent =  request.env['HTTP_USER_AGENT'].downcase 
  @users_browser ||= begin
    if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
          true
      elsif user_agent.index('gecko/')
          false
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
