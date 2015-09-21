class FirstController < CShopController
def preview
	end
def pricing1
end
def pricing2
end
def pricing3
end		
def subscription

end	
def contact

		UserMailer.contact(params[:name],params[:email],params[:comments]).deliver
	 redirect_to :action => 'start'

	end 
	def preview
		@t=Masterusers.all
		@theme=params[:theme]
	end
	def master_signup 

		begin 
			if params[:commit] == "Create My Store" then
				if params[:name] ==''  then 
				flash[:notice] = "#{'shop name is mandatory'}"
			redirect_to :action=>'start'
				else
					Masterusers.create(:url_name => params[:name])
					# Mastermailer.master_welcome_email( a,params[:name],params[:email]).deliver
				#	MasterMailer.master_welcome_email(params[:name],params[:email]).deliver
					session[:master_user_id]=(Masterusers.last).master_user_id	
					session[:flag] = "true"					
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
	unless File.directory?("public/images/#{session[:master_user_id]}")
				Dir.mkdir"public/images/#{session[:master_user_id]}"
			end
	@test=params[:commit]
	@t=Masterusers.all
	#begin
		if params[:commit]== "Submit" then
			
			@test=params[:commit]
			if params[:password] == params[:confirmpassword] then
			
			params[:emailaddress] =='' ? nil : params[:emailaddress]
				#Masterusers.find_by_sql(["UPDATE masterusers SET address =?,landmark=?,city=?,state=?, pincode=?,country=?,phone=? WHERE master_user_id=?",params[:address],params[:landmark],params[:city],params[:state],params[:pincode],params[:country],params[:phone],session[:master_user_id]])	
				#Masterusers.find_by_sql(["UPDATE masterusers SET theam =? WHERE master_user_id=?",params[:theme],session[:master_user_id]])	
				
			if !params[:upload1].blank?
			name = params[:upload1][:file].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/slider_1.#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload1][:file].read) }
			
			@path1 = "/images/#{session[:master_user_id]}/slider_1.#{name}"
			end	
			if !params[:upload2].blank?
			name = params[:upload2][:file].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/slider_2.#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload2][:file].read) }
			
			@path2 = "/images/#{session[:master_user_id]}/slider_2.#{name}"
			end	
			if !params[:upload3].blank?
			name = params[:upload3][:file].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/slider_3.#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload3][:file].read) }
			
			@path3 = "/images/#{session[:master_user_id]}/slider_3.#{name}"
			end	
				
				Masterusers.find_by_sql(["UPDATE masterusers SET shop_name =?,first_name=?,last_name=?,master_email=?, password=?,address =?,landmark=?,city=?,state=?, pincode=?,country=?,phone=?,slide_1=?,slide_2=?,slide_3=? WHERE master_user_id=?",params[:shopname],params[:firstname],params[:lastname],params[:emailaddress],params[:password],params[:address],params[:landmark],params[:city],params[:state],params[:pincode],params[:country],params[:phone],@path1,@path2,@path3,session[:master_user_id]])	
				#Masterusers.find_by_sql(["UPDATE masterusers SET last_name=?,master_email=?, password=? WHERE master_user_id=?",params[:lastname],params[:emailaddress],params[:password],session[:master_user_id]])	
				session[:flag] = "false"
				redirect_to :action => 'create_shop',:name=>"ok"
			else
			flash[:notice] = "#{'password and confirm password does not match'}"
					redirect_to :action => 'c_step_2'
			end
		end
	#rescue => e 
	#flash[:notice] = "#{'this email already exists'}"
	
	#end
	
		if params[:email]=="emailtest" then 
			@sub_user=Masterusers.find_by_sql("select count() from masterusers  where master_email='#{params[:testemail]}'")
			if @sub_user[0]['count()']>0 then 
				@flash=" #{@sub_user[0]['count()']} email Id   already  "
				@ajaxsearch="error"
				respond_to do |format|
					format.html # index.html.erb
					format.js   # index.js.erb
					format.json { render json: @ajaxsearch  }
					format.json { render json: @flash}
				end
			else
				@ajaxsearch="ok"
				respond_to do |format|
					format.html # index.html.erb
					format.js   # index.js.erb
					format.json { render json: @ajaxsearch  }
					
				end
			end
		end 		
		if params[:name]=="theme" then 
					Masterusers.find_by_sql(["UPDATE masterusers SET theam =? WHERE master_user_id=?",params[:theme],session[:master_user_id]])	
						
					@ajaxsearch="theme"
				
				respond_to do |format|
					format.html # index.html.erb
					format.js   # index.js.erb
					format.json { render json: @ajaxsearch  }
					
				end
		end 		
	end
	
	
	def start		
		render :layout => 'startpage'
	end
	def about
	end
	def blog
	end
	def faq
	end
end
