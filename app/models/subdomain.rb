class Subdomain < ActiveRecord::Base
  belongs_to :user
  
  def self.find_by_subdomain(requested)
    found = Subdomain.where(:name => requested).first
  end
  
  def self.unzip(filename, dir)
    command = "unzip -u -d #{dir} #{filename}"
    success = system(command)
    # File.delete(filename)
    
    success && $?.exitstatus == 0
  end
  
  def self.move_up(dir, name)
    File.delete("#{dir}/#{name}")
    Dir.foreach(dir) do |e|
      if File.directory?("#{dir}/#{e}")
        next if e == '.' || e == '..' || e == "__MACOSX"
        command = "mv #{dir}/#{e}/* #{dir}"
        system(command)
        #remove the zip parent directory this does not error gracefully
        Dir.delete("#{dir}/#{e}")
      end
    end
  end
end
