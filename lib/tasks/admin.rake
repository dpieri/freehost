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

task :checkForDupes => :environment do
  subs = Subdomain.find(:all)
  subs.each do |s|
    subs.each do |ss|
      puts "#{s.name} : #{s.user_id} and #{ss.name} : #{ss.user_id}" if s != ss && s.name.downcase == ss.name
      s.delete if s != ss && s.name.downcase == ss.name
    end
  end
end

task :downcase => :environment do 
  subs = Subdomain.find(:all)
  subs.each do |s|
    command = "mv #{ASSETS_ROOT}/user_#{s.name} #{ASSETS_ROOT}/user_#{s.name.downcase}"
    system(command)
    # if s.name.downcase != s.name
    #   puts "not equal"
    #   s.name = s.name.downcase
    #   s.save
    #   command = "mv #{ASSETS_ROOT}/user_#{s.name} #{ASSETS_ROOT}/user_#{s.name.downcase}"
    #   system(command)
    # end
  end
end


desc "fix users without keys"
task :fixKeys => :environment do
  # User.where("key is null").each do |u|
  #   u.subdomains.each do |s|
  #     puts "subdomain: #{s.name} key:#{s.key}"
  #   end
  # end
  
  Subdomain.find_each do |s|
    next if s.user.nil?
    next unless s.is_confirmed == true
    if s.user.key.nil? && s.key
      puts "sub key is #{s.key}"
      s.user.key = s.key
      s.user.save
    elsif s.key.nil? && s.user.key
      puts "user key is #{s.user.key}"
      s.key = s.user.key
      s.save
    elsif s.user.key.nil?
      puts "no key for #{s} on user #{s.user}"
      key = Array.new(15) { (rand(122-97) + 97).chr }.join
      s.key = key
      s.user.key = key
      s.save
      s.user.save
    end
  end
  
  User.find_each do |u|
    next unless u.key.nil?
    puts "nil user #{u.id}"
    u.key = Array.new(15) { (rand(122-97) + 97).chr }.join
    u.save
    puts "with subdomains #{u.subdomains.length}"
  end
  puts "something"
  puts User.find(:all).count
end