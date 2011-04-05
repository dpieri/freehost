module ApplicationHelper
  
  def self.fetch_thumbnail(url)
    date = Time.now.gmtime.strftime("%Y%m%d")
    key = 'f48f1f5fc910564a8f03a03bd455536c'
    hash = Digest::MD5.hexdigest("#{date}#{url}#{key}")
    "http://webthumb.bluga.net/easythumb.php?url=#{url}&cache=1&hash=#{hash}&user=11144&size=large"
  end
end
