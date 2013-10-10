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
       
        if params[:commit]=="Submit" then 
            test= Masterusers.find_by_sql("select * from product_sub_category_"+session[:master_user_id].to_s+ " where product_category_id ='"+ params[:category_id].to_s+"' and sub_category_name='"+params[:c_name].to_s+"'")
            if test=test[0].nil?
               Masterusers.find_by_sql(["INSERT INTO product_sub_category_"+session[:master_user_id].to_s+"(sub_category_name,product_category_id) VALUES (?,?)",params[:c_name], params[:category_id]])                        
            else 
			  flash[:notice] = "#{params[:c_name]+' Category Name already exist this category '}"
			end
			   
		    redirect_to :action =>"add_category"
       end
	end
	def adminhome
		session[:adminflag] == "true"
	end

	def add_category
		if params[:commit]=="submit" then
			test= Masterusers.find_by_sql("select * from product_category_"+session[:master_user_id].to_s+ " where product_category_name ='"+ params[:c_name].to_s+"'")
			if test[0].nil?
			#if params[:commit]=="submit" then
			Masterusers.find_by_sql(["INSERT INTO product_category_"+session[:master_user_id].to_s+"(product_category_name) VALUES (?)",params[:c_name]])			
			else
			flash[:notice] = "#{params[:c_name]+'  SubCategory Name already exist'}"
			end
		#render :layout=>"master"
		end
		
	end
	def category_detail
		@category = Masterusers.find_by_sql("select * from product_category_"+session[:master_user_id].to_s)
		@sub_category = Masterusers.find_by_sql("select * from product_sub_category_"+session[:master_user_id].to_s)
		
		if params[:value] == "delete_category"
               Masterusers.find_by_sql(["delete from product_category_"+session[:master_user_id].to_s+" where product_category_id = "+params[:product_category_id].to_s])
				 Masterusers.find_by_sql(["delete from product_sub_category_"+session[:master_user_id].to_s+" where product_category_id = "+params[:product_category_id].to_s])
			  redirect_to :action => 'category_detail'
       end
	   
	   if params[:value] == "delete_sub_category"
               Masterusers.find_by_sql(["delete from product_sub_category_"+session[:master_user_id].to_s+" where sub_category_id = "+params[:sub_category_id].to_s])
               redirect_to :action => 'category_detail'
       end
	   
	   if params[:commit] == "save"
	   @test = params[:categoryname]
	   @x = params[:category]
	   Masterusers.find_by_sql("UPDATE product_category_"+session[:master_user_id].to_s+" SET product_category_name = ' "+params[:categoryname].to_s+" ' WHERE product_category_id = "+params[:category].to_s)
	   redirect_to :action => 'category_detail'
	   end
	   if params[:commit] == "submit"
	   @test = params[:subcategoryname]
	   @x = params[:subcategory]
	   Masterusers.find_by_sql("UPDATE product_sub_category_"+session[:master_user_id].to_s+" SET sub_category_name = ' "+params[:subcategoryname].to_s+" ' WHERE sub_category_id = "+params[:subcategory].to_s)
	   redirect_to :action => 'category_detail'
	   end
	   
	end
	
	def inventory
		
		#@display = Masterusers.find_by_sql("select * from product_category_"+session[:master_user_id].to_s)
		
		if params[:name] == "movement"
			@flag = "movement"
		end
		if params[:name] == "status"
			@flag = "status"
		end
		if params[:name] == "report"
			@flag = "report"
		end
		if params[:commit] == "submit"
			@flag = "report"
			
			@start = params[:start_date]
			@end = params[:end_date]
			#@display = Masterusers.find_by_sql("select * from order_"+session[:master_user_id].to_s+" where order_status = 'delivered'")
			@display = Masterusers.find_by_sql("select * from order_"+session[:master_user_id].to_s+" where order_status = 'Delivered' and delivery_date between '"+params[:start_date]+"' and '"+params[:end_date]+"'" )
			
			
		end
		
		if params[:commit] == "ok"
			@flag = "status"
			@test = params[:product_id]
			@name = Masterusers.find_by_sql("select product_name, product_id, quantity,out_quantity from product_"+session[:master_user_id].to_s+" where product_id = "+params[:product_id])
		end
		 @ajaxsearch=params[:filter];
		
		if @ajaxsearch=="sub_category" then 
			@sub =Masterusers.find_by_sql("select * from product_sub_category_"+session["master_user_id"].to_s+" where product_category_id='"+params[:category_id].to_s+"'")
			
			respond_to do |format|
				format.html # index.html.erb
				format.js   # index.js.erb
				format.json { render json: @sub  }
				format.json { render json: @ajaxsearch  }
				end
		end
		if @ajaxsearch =="product"
		@product =Masterusers.find_by_sql("select * from product_"+session["master_user_id"].to_s+" where sub_category_id=1")
		
			respond_to do |format|
				format.html # index.html.erb
				format.js   # index.js.erb
				format.json { render json: @product  }
				format.json { render json: @ajaxsearch  }
			end
		end
		
	end
	def add_product
	
		@test=Masterusers.find_by_sql("select * from product_category_"+session[:master_user_id].to_s)
		@q=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s)	
		if params[:commit]=="Submit" then 	
			a=Masterusers.find_by_sql("SELECT Max(product_id) FROM product_"+session[:master_user_id].to_s )
			product_id=a[0]['Max(product_id)']
			if !params[:upload1].blank?
			name = params[:upload1][:file].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/#{product_id.to_s}.#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload1][:file].read) }
			@path1 = "/images/#{session[:master_user_id]}/#{product_id.to_s}.#{name}"
			end	
			
			if !params[:upload2].blank?
			name = params[:upload1][:file].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/#{product_id.to_s}(1).#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload2][:file].read) }
			
			@path2 = "/images/#{session[:master_user_id]}/#{product_id.to_s}(1).#{name}"
			end	
			
			if !params[:upload3].blank?
			name = params[:upload1][:file].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/#{product_id.to_s}(2).#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload3][:file].read) }
			@path3 = "/images/#{session[:master_user_id]}/#{product_id.to_s}(2).#{name}"
			end
			
			if  params[:comment_checkbox] == "comment" then 
			comment =true
			end
			if params[:shipping_checkbox] == "shipping" then
			shipping=true
			end
			Masterusers.find_by_sql(["INSERT INTO product_"+session[:master_user_id].to_s+"(product_name,product_category_id,sub_category_id,quantity,sale_price,price,title,description,image_1,image_2,image_3,shipping,comment) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",params[:productname],params[:category_id],params[:subcategory_id].to_s,params[:quantity],params[:saleprice],params[:price],params[:title],params[:description],@path1,@path2,@path3,shipping,comment])			
			#Masterusers.find_by_sql(["INSERT INTO product_details_"+session[:master_user_id].to_s+"(product_name,product_category_id,sub_category_id,quantity,sale_price,price) VALUES (?,?,?,?,?,?)",params[:productname],params[:category_id],params[:subcategory_id].to_s,params[:quantity],params[:saleprice],params[:price]])
		flash[:notice] = "#{'  Product Added Sucessfully now add another product'}"
			
		end
		 @sub =Masterusers.find_by_sql("select * from product_sub_category_"+session["master_user_id"].to_s+" where product_category_id='"+params[:category_id].to_s+"'")
		 #@sub =Masterusers.find_by_sql("select * from product_sub_category_#{session[:master_user_id]}" )
		
		respond_to do |format|
		format.html # index.html.erb
		format.js   # index.js.erb
		format.json { render json: @sub  }
		
		end
		
		
			
	end
	def order_status
		
		if params[:order_status]=="Ready for Dispatch"
			Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set order_status= 'Ready for Dispatch' where order_id="+params[:order_id].to_s)
		end
		if params[:order_status]=="Dispatch"
			Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set order_status= 'Dispatch' where order_id="+params[:order_id].to_s)
		end
		
		if params[:filter]=="Mark as Dispatch"
			Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set order_status= 'Dispatch' where order_id="+params[:order_id].to_s)
		end
		
		
		  redirect_to :action => 'order'
	end
	def order
	
		@order=Masterusers.find_by_sql("select * from order_"+ session["master_user_id"].to_s + " where canceled = 'false'" )
		if params[:order_status]=="Ready for Dispatch"
			Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set order_status= 'Ready for Dispatch' where order_id="+params[:order_id].to_s)
		end
		if params[:order_status]=="Dispatch"
			Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set order_status= 'Dispatch' where order_id="+params[:order_id].to_s)
		end
		
		if params[:filter]=="Mark as Dispatch"
			Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set order_status= 'Dispatch' where order_id="+params[:order_id].to_s)
		end
		if params[:order_status]=="Panding"
			Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set order_status= 'Panding' where order_id="+params[:order_id].to_s)
		end
		if params[:order_status]=="Delivered"
                       Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set order_status= 'Delivered',delivery_date='"+ Time.now.strftime("%m/%d/%Y") + "' where order_id="+params[:order_id].to_s)
					   @x1= Masterusers.find_by_sql("select product_id from order_"+session[:master_user_id].to_s+" where order_id = "+params[:order_id].to_s)
					   @p = @x1[0]['product_id'].split(" ")
					   @p.each do |a|			
						b=a.split("-")
						@a=b[0]
						out = Masterusers.find_by_sql("select out_quantity from product_"+session[:master_user_id].to_s+" where product_id = "+b[0])
						out = out[0]['out_quantity'] - b[1].to_i
						Masterusers.find_by_sql(["update product_"+session[:master_user_id].to_s+" set out_quantity = ? where product_id = ?",out,b[0]])
						end
               end
		 if params[:commit]=="submit"
		 @order=Masterusers.find_by_sql("select * from order_"+ session["master_user_id"].to_s + " where order_id="+params[:order_id] )
		 Masterusers.find_by_sql("update  order_"+session[:master_user_id].to_s+" set canceled= 'true',canceled_reason='"+ params[:reason] +"' where order_id="+params[:order_id].to_s)
			MasterMailer.Order_canceled(@order[0]['email'],@order[0]['product_id'],session[:master_user_id],params[:reason]).deliver		
		
		end
		if params[:filter]=="all"
		#@test=params[:filter_order_id]
		@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s])
		end
		if params[:filter]=="cod"
		#@test=params[:filter_order_id]
		@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where cod_confirm = 'true'"])
		
		end
		if params[:filter]=="canceled"
		#@test=params[:filter_order_id]
		@order = Masterusers.find_by_sql("select * from order_"+session[:master_user_id].to_s+" where canceled='true'")
		end
		if params[:filter]=="delivered"
		#@test=params[:filter_order_id]
		#@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_id = "+params[:filter_order_id]])
		end
		if params[:filter]=="pending"
		#@test=params[:filter_order_id]
		@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_status = 'panding'"])
		end
		if params[:filter]=="rod"
		#@test=params[:filter_order_id]
		#@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_id = "+params[:filter_order_id]])
		end
		if params[:filter]=="shipped"
		#@test=params[:filter_order_id]
		#@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_id = "+params[:filter_order_id]])
		end
		if params[:filter]=="epayment"
		#@test=params[:filter_order_id]
		#@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_id = "+params[:filter_order_id]])
		end
	
	
		
		if !params[:order_date].nil?
		@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_date = '"+params[:order_date]+"'"])
		end		
		if params[:search_mode]=="filter_order_id"
		#@test=params[:filter_order_id]
		@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_id = "+params[:filter_order_id]])
		end
		if params[:search_mode]=="filter_order_id"
		#@test=params[:filter_order_id]
		@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_id = "+params[:filter_order_id]])
		end
		if params[:search_mode]=="filter_customer"
		@order = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where name = '"+params[:filter_order_id]+"'"])
		end
		if params[:search_mode]=="filter_payment_mode"
		end
		if params[:search_mode]=="filter_courier_company"
		end
		if params[:search_mode]=="filter_awb_number"
		end
		if params[:g] == 'order_detail'
			@products = Masterusers.find_by_sql(["select product_id from order_"+session[:master_user_id].to_s+" where order_id = "+params[:id]])
			@x = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_id = "+params[:id]])
			@x=@x[0]
			c=@products[0]["product_id"].split(" ")
			@p=c
			@a=@products[0]['product_id'].split(/[-]+[\d]*[\s]*/)
		end
		
		respond_to do |format|
		format.html # index.html.erb
		format.js   # index.js.erb
		format.json { render json: @x  }
		format.json { render json: @p  }
		format.json { render json: @a  }
		end
		
		
		
	end
	
	def customer_detail
	#@a = params[:sub_user_id]
	if params[:value] == "delete"
		Masterusers.find_by_sql(["delete from subuser_"+session[:master_user_id].to_s+" where sub_user_id = "+params[:sub_user_id].to_s])
		redirect_to :action => 'customer_detail'
	end
	
	end
	
	def admin_logout
		if params[:value] == "logout" then
			#session[:master_user_id] = 0
			session[:adminflag] = "false"
			redirect_to :controller=> 'c_shop', :action => 'home'
		end
	end
	

end
