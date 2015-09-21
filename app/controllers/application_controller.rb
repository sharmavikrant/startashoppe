class ApplicationController < ActionController::Base
  protect_from_forgery
before_filter :whichuser
  def whichuser 
		if request.domain == "startashoppe.com" then 
			if (!Masterusers.find_by_url_name(request.subdomain).nil?) then 
				@t=Masterusers.find_by_url_name(request.subdomain)
				session[:theme]=@t.theam
				session[:master_user_id]=@t.master_user_id

			else
				
			end
		else
			@t=Masterusers.find_by_domain_name(request.domain)
				session[:theme]=@t.theam
				session[:master_user_id]=@t.master_user_id
			
		end 	
  end 
end
