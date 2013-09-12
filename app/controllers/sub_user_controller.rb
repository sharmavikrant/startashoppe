class SubUserController <CShopController

	def test
		@x = Masterusers.find_by_sql(["select * from subuser_"+session[:master_user_id].to_s])
	end

	def subuser_signup
		if params[:commit]=="signup" then
			connection = ActiveRecord::Base.connection();
			
			#Masterusers.find_by_sql(["INSERT INTO subuser_"+session[:master_user_id].to_s+"(first_name,last_name,address,city,state,pincode,country,phone,subuser_email,password) VALUES (?,?,?,?,?,?,?,?,?,?)",params[:first_name], params[:last_name],params[:address], params[:city],params[:state], params[:pincode],params[:country], params[:phone],params[:subuser_email], params[:password]])                        
			redirect_to :action => 'subuser_login'
		end
	end

	def subuser_login
		if params[:commit] == "login" then
			connection = ActiveRecord::Base.connection();
			#@t= "select * from properties_" + session[:master_user_id].to_s+ " where sub_user_id = "+params[:loginid]
			member=connection.execute("select * from subuser_" + session[:master_user_id].to_s+ " where subuser_email = " +"'"+params[:email].to_s+"'")	
			
			if member != nil then
				if   member[0]["password"]==params[:password]
				session[:subuser_id]=params[:loginid]
					redirect_to :action => 'home'
				else
                    flash[:notice] = "#{'Incorrect Password details'}"        
                    redirect_to :action => 'subuser_login'
                end        
                
            else
				flash[:notice] = "#{'Invalid Email address'}"        
				redirect_to :action => 'subuser_login'
			end
		
		end
		
	end

end
