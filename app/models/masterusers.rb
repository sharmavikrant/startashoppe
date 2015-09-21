class Masterusers < ActiveRecord::Base
attr_accessible  :master_user_id,:url_name,:password,:shop_name,:first_name,:last_name,:address,:landmark,:city,:state,:pincode,:country,:phone,:master_email,:validate,:theam 
	validates :url_name, :presence=>true,:uniqueness =>true,:format=> { with: /\A[a-z0-9]+\z/, message: "only allows Small letters and Numbers" }
	#validates :master_email, :presence=>true,:uniqueness =>true



def self.weekly
Masterusers.find_by_sql(["update masterusers set theam = 'theme_3' where master_user_id = 125"])		
end




	
	def self.shop_search(subdomain)
	 if (!Masterusers.find_by_url_name(subdomain).nil?) then 
                   t=Masterusers.find_by_url_name(subdomain).master_user_id
                      
               else
			   
					
					
               end
	end
	def self.title(title)
		title.parameterize
        end




 def self.controller_search(subdomain)
         if (!Masterusers.find_by_url_name(subdomain).nil?) then
                   t=Masterusers.find_by_url_name(subdomain).theam
			if t =='theme_2' then 
				return "c_shop3"
			end 

               else



               end
        end





end
