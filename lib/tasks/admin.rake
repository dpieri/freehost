desc "Clear users before launch"
task :clearUsers => :environment do
  User.find(:all).each do |u|
    u.delete
  end
  
  Subdomain.find_each do |s|
    s.delete
  end
  
  subdomains = Subdomain.create([{:name => 'www', :is_confirmed => true}, {:name => 'coralrift', :is_confirmed => true}, {:name => 'asdf', :is_confirmed => true}])
end

desc "clear unclaimed subdomains"
task :clearUnClaimed => :environment do
  Subdomain.find_each do |s|
    s.delete if s.is_confirmed == false || s.is_confirmed.nil? && Time.now - 24.hours > s.created_at
  end
end


desc "fix users without keys"
task :fixKeys => :environment do
  User.where("key is null").each do |u|
    u.subdomains.each do |s|
      puts "subdomain: #{s.name} key:#{s.key}"
    end
  end
  
  Subdomain.find_each do |s|
    next if s.user &&  s.user.key
    puts s.user.email
    puts s.key
    puts s.user.key
  end
end