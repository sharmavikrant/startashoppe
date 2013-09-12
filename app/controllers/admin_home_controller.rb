class AdminHomeController <CShopController

	def test
	
		render :layout=>"master"
	end
	def adminlogin
               if params[:commit] == "login" then
                       if  member = Masterusers.find_by_master_email(params[:email]) then 
                               user_details =Masterusers.find_by_master_email(params[:email])
                               if user_details.password ==params[:password] then 
                               session[:master_user_id]= user_details.master_user_id
                               
                               redirect_to :action => 'adminhome'
                               else
                               flash[:notice] = "#{'Incorrect Password details'}"        
                                       #render "login"
                                       redirect_to :action => 'adminlogin'
                               end        
                       #redirect_to :controller=>session[:master_user_id], :action => 'home'
                       else
                       flash[:notice] = "#{'Invalid Email address'}"        
                       #render "login"
                       redirect_to :action => 'adminlogin'
                       end        
               end
       end
	   
	   def add_subcategory
       
               if (!Masterusers.find_by_url_name(request.subdomain).nil?) then 
             @t=Masterusers.find_by_url_name(request.subdomain)
              session[:master_user_id]=@t.master_user_id       
                               @t=session[:master_user_id]
                               
               end
               
               if params[:commit]=="Submit" then 
               Masterusers.find_by_sql(["INSERT INTO product_sub_category_"+session[:master_user_id].to_s+"(sub_category_name,product_category_id) VALUES (?,?)",params[:c_name], params[:category_id]])                        
               end
			   
			   render :layout=>"master"
       end

def adminhome

end

	def add_category
		if params[:commit]=="submit" then
		Masterusers.find_by_sql(["INSERT INTO product_category_"+session[:master_user_id].to_s+"(product_category_name) VALUES (?)",params[:c_name]])			
		end
		render :layout=>"master"
	end
	
	def add_product
	
		render :layout=>"master"
		
		@test=Masterusers.find_by_sql("select * from product_category_"+session[:master_user_id].to_s)
		@q=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s)
		if (!Masterusers.find_by_url_name(request.subdomain).nil?) then 
              @t=Masterusers.find_by_url_name(request.subdomain)
               session[:master_user_id]=@t.master_user_id       
				@t=session[:master_user_id]
				
		end
	
		
				
		if params[:commit]=="Submit" then 
				
			connection = ActiveRecord::Base.connection();
			#Properties.find_by_sql(["INSERT INTO product_"+session[:master_user_id].to_s+"(product_name,product_category_id,sub_category_id,quantity,sale_price,price) VALUES (?,?,?,?,?,?,)",params[:productname],params[:price],params[:state],property_type,purpose,params[:bedroom].to_i,@path1,sub_property_type,params[:contant],Time.now.strftime("%m/%d/%Y"),Time.now.strftime("%m/%d/%Y")])
			
			#Masterusers.find_by_sql(["INSERT INTO product_"+session[:master_user_id].to_s+"(product_name,product_category_id) VALUES (?,?)",params[:productname],params[:category_id].to_s])
		
		
			if !params[:upload1].blank?
			name = params[:upload1][:file].original_filename
			directory = "public/images/"
			@path = File.join(directory, name)
			File.open(@path, "wb") { |f| f.write(params[:upload1][:file].read) }
			flash[:notice] = "File uploaded"
			@path1 = File.join("/images/", name)
			end	
			
			if !params[:upload2].blank?
			name = params[:upload2][:file].original_filename
			directory = "public/images/"
			@path = File.join(directory, name)
			File.open(@path, "wb") { |f| f.write(params[:upload2][:file].read) }
			flash[:notice] = "File uploaded"
			@path2 = File.join("/images/", name)
			end	
			
			if !params[:upload3].blank?
			name = params[:upload3][:file].original_filename
			directory = "public/images/"
			@path = File.join(directory, name)
			File.open(@path, "wb") { |f| f.write(params[:upload3][:file].read) }
			flash[:notice] = "File uploaded"
			@path3 = File.join("/images/", name)
			end
			
			if  params[:comment_checkbox] == "comment" then 
			comment =true
			end
			if params[:shipping_checkbox] == "shipping" then
			shipping=true
			end
			Masterusers.find_by_sql(["INSERT INTO product_"+session[:master_user_id].to_s+"(product_name,product_category_id,sub_category_id,quantity,sale_price,price,title,description,image_1,image_2,image_3,shipping,comment) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",params[:productname],params[:category_id],params[:subcategory_id].to_s,params[:quantity],params[:saleprice],params[:price],params[:title],params[:description],@path1,@path2,@path3,shipping,comment])			
			#Masterusers.find_by_sql(["INSERT INTO product_details_"+session[:master_user_id].to_s+"(product_name,product_category_id,sub_category_id,quantity,sale_price,price) VALUES (?,?,?,?,?,?)",params[:productname],params[:category_id],params[:subcategory_id].to_s,params[:quantity],params[:saleprice],params[:price]])
		
		end
			
		
			
	end
	

end
