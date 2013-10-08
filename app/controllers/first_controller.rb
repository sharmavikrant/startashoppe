class FirstController < CShopController

	def preview
		@t=Masterusers.all
		@theme=params[:theme]
	end
	def master_signup 
		begin 
			if params[:commit] == "upload" then
				if params[:name] ==''  then 
				flash[:notice] = "#{'shop name is mandatory'}"
			redirect_to :action=>'start'
				else
					Masterusers.create(:url_name => params[:name])
					# Mastermailer.master_welcome_email( a,params[:name],params[:email]).deliver
					MasterMailer.master_welcome_email(params[:name],params[:email]).deliver
					session[:master_user_id]=(Masterusers.last).master_user_id	 
					redirect_to :action => 'c_step_2'
				end
			end
		rescue => e 	
			flash[:notice] = "#{'Shop URL must be unique "'+ params[:name]+'" this URL already exist'}"
			redirect_to :action=>'start'
		end
				
	end
	
	def c_step_1
	
		
			
				
		Masterusers.find_by_sql(["UPDATE masterusers SET theam =? WHERE master_user_id=?",params[:theme],session[:master_user_id]])	
				
	
		redirect_to :action => 'c_step_2'
	end
	
	def c_step_2
	@test=params[:commit]
	@t=Masterusers.all
	begin
		if params[:commit]== "Submit" then
			
			@test=params[:commit]
			if params[:password] == params[:confirmpassword] then
			
			params[:emailaddress] =='' ? nil : params[:emailaddress]
				#Masterusers.find_by_sql(["UPDATE masterusers SET address =?,landmark=?,city=?,state=?, pincode=?,country=?,phone=? WHERE master_user_id=?",params[:address],params[:landmark],params[:city],params[:state],params[:pincode],params[:country],params[:phone],session[:master_user_id]])	
				#Masterusers.find_by_sql(["UPDATE masterusers SET theam =? WHERE master_user_id=?",params[:theme],session[:master_user_id]])	
				session[:flag] = "true"
				Masterusers.find_by_sql(["UPDATE masterusers SET shop_name =?,first_name=?,last_name=?,master_email=?, password=?,address =?,landmark=?,city=?,state=?, pincode=?,country=?,phone=? WHERE master_user_id=?",params[:shopname],params[:firstname],params[:lastname],params[:emailaddress],params[:password],params[:address],params[:landmark],params[:city],params[:state],params[:pincode],params[:country],params[:phone],session[:master_user_id]])	
				#Masterusers.find_by_sql(["UPDATE masterusers SET last_name=?,master_email=?, password=? WHERE master_user_id=?",params[:lastname],params[:emailaddress],params[:password],session[:master_user_id]])	
				redirect_to :action => 'shop_search',:name=>"ok"
			else
			flash[:notice] = "#{'password and confirm password does not match'}"
					redirect_to :action => 'c_step_2'
			end
		end
	rescue => e 
	flash[:notice] = "#{'this email already exists'}"
	
	end
	
		
	end
	
	
	def start		
	end
	def about
	end
	def blog
	end
	

end
