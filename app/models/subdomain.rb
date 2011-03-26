class Subdomain < ActiveRecord::Base
  belongs_to :user
  
  def self.find_by_subdomain(requested)
    found = Subdomain.where(:name => requested).first
  end
  
  def self.unzip(filename, dir)
    command = "unzip -u -d #{dir} #{filename}"
    success = system(command)
    
    success && $?.exitstatus == 0
  end
  
  def self.move_up(dir, name)
    zip_dir = "#{dir}/#{name.sub('.zip', '')}"
    if File.directory?(zip_dir)
      puts "directory"
      command = "mv #{zip_dir}/* #{dir}"
      system(command)
      command = "rm -rf #{zip_dir}"
      system(command)
    end
  end
end
