class Subdomain < ActiveRecord::Base
  belongs_to :user
  
  def self.find_by_subdomain(requested)
    found = Subdomain.where(:name => requested).first
  end
end
