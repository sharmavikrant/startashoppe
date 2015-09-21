class Masterusers < ActiveRecord::Base
attr_accessible  :master_user_id,:url_name,:password,:shop_name,:first_name,:last_name,:address,:landmark,:city,:state,:pincode,:country,:phone,:master_email,:validate,:theam 

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
