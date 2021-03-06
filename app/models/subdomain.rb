class Subdomain < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 30, :on => :create #doesn't do anything right now
  
  def self.find_by_subdomain(requested)
    found = Subdomain.where(:name => requested).first
  end
  
  def self.unzip(subdomain, file)
    directory = "#{ASSETS_ROOT}/user_#{subdomain}"
    # puts "directory is #{directory}"
    file_path = "#{ASSETS_ROOT}/uploads/#{file}"
    # puts "file path is #{file_path}"
    Dir.mkdir directory unless File.directory?(directory)
    #empty directory
    Dir.foreach(directory) do |f|
      if f == '.' || f == '..' || f == '__MACOSX'
        next
      elsif File.directory?("#{directory}/#{f}")
        FileUtils.rm_rf("#{directory}/#{f}")
      elsif File.exists?("#{directory}/#{f}")
        FileUtils.rm("#{directory}/#{f}")
      end
    end
    command = "unzip -u -d #{directory} #{file_path}"
    success = system(command)
    #delete the zip
    File.delete(file_path)
    
    success && $?.exitstatus == 0
  end
  
  def self.move_up(subdomain)
    # File.delete("#{dir}/#{name}")
    directory = "#{ASSETS_ROOT}/user_#{subdomain}"
    Dir.foreach(directory) do |e|
      if File.directory?("#{directory}/#{e}")
        next if e == '.' || e == '..' || e == "__MACOSX"
        # File.chmod(0766, "#{directory}/#{e}")
        FileUtils.chmod_R(0777, "#{directory}/#{e}")
        command = "mv #{directory}/#{e}/* #{directory}"
        system(command)
        #remove the zip parent directory this does not error gracefully
        command = "rm -rf #{directory}/#{e}"
        system(command)
        # Dir.delete("#{directory}/#{e}")
      else
        next if e == '.' || e == '..' || e == "__MACOSX"
        File.chmod(0777, "#{directory}/#{e}")
      end
    end
  end
end
