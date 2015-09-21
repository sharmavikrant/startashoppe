class AdminHomeController <ApplicationController

		#layout "master", :except => [:adminlogin,:admin_logout]

	before_filter :authorize
	def product_view

		if session[:flag]==false||session[:flag]==nil then 
			redirect_to :action => 'adminlogin'
		else
			@product = Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s)
			@cat = Masterusers.find_by_sql("select * from product_category_#{session[:master_user_id]} ")
			@sub = Masterusers.find_by_sql("select * from product_sub_category_#{session[:master_user_id]} ")
				
			if params[:value] == "delete_product"
				Masterusers.find_by_sql(["delete from product_"+session[:master_user_id].to_s+" where product_id = "+params[:product_id].to_s])
				#redirect_to :action => 'product_view'
			 end
			 
			 
		end 
	end
	def product_edit

		if session[:flag]==false||session[:flag]==nil then 
			redirect_to :action => 'adminlogin'
		else
			@product = Masterusers.find_by_sql("select * from product_#{session[:master_user_id]} where product_id = #{params[:product_id]}" )
			 if params[:commit] == "submit"
				
				Masterusers.find_by_sql(["UPDATE product_"+session[:master_user_id].to_s+" SET product_name = ' "+params[:productname].to_s+" ' , title = ' "+params[:title].to_s+" ' , product_category_id = ' "+params[:category_id].to_s+" ', sub_category_id = ' "+params[:sub_category_id].to_s+" ', price = ' "+params[:price].to_s+" ', sale_price = ' "+params[:sales_price].to_s+" ',quantity = ' "+params[:quantity].to_s+" ' WHERE product_id = #{params[:product_id]}" ])
				if !params[:upload1].blank?
					name = params[:upload1][:file].original_filename
					name=name.split(".").last
					if @test=['gif','png','jpg','jpeg'].include?(name)   then 
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/#{params[:productname].parameterize}_#{params[:product_id]}(1).#{name}"
						File.open(@path, "wb") { |f| f.write(params[:upload1][:file].read) }
						image = MiniMagick::Image.open(@path)
						@user_name="#{session[:master_user_id]}";
						@product_name_1="#{params[:productname].parameterize}_#{params[:product_id]}(1).#{name}"
						image.resize "200x200"
						image.write(Rails.root.join('public', 'images',@user_name,'thumb' ,@product_name_1))
						@path1 = "/images/#{session[:master_user_id]}/"
						Masterusers.find_by_sql(["UPDATE product_"+session[:master_user_id].to_s+" SET image_1 = ? ,image_name_1 = ? WHERE product_id =?", @path1,@product_name_1, params[:product_id] ])
					else
						flash[:upload] = "#{'only GIF , PNG , JPG , JPEG   then  file formates allowed '}"
					end
						
				end	

				if !params[:upload2].blank?

					name = params[:upload2][:file].original_filename

					name=name.split(".").last
					if @test=['gif','png','jpg','jpeg'].include?(name)   then 
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/#{params[:productname].parameterize}_#{params[:product_id]}(2).#{name}"
						File.open(@path, "wb") { |f| f.write(params[:upload2][:file].read) }
						image = MiniMagick::Image.open(@path)
		                @user_name="#{session[:master_user_id]}";
		                @product_name_2="#{params[:productname].parameterize}_#{params[:product_id]}(2).#{name}"
		                image.resize "200x200"
		                image.write(Rails.root.join('public', 'images',@user_name,'thumb' ,@product_name_2))
		                @path2 = "/images/#{session[:master_user_id]}/"
						Masterusers.find_by_sql(["UPDATE product_"+session[:master_user_id].to_s+" SET image_2 = ? ,image_name_2 = ? WHERE product_id =?", @path2,@product_name_2, params[:product_id] ])
					else
						flash[:upload] = "#{'only GIF , PNG , JPG , JPEG   then  file formates allowed '}"
					end
					
				end	
				if !params[:upload3].blank?
					name = params[:upload3][:file].original_filename
					name=name.split(".").last
					if @test=['gif','png','jpg','jpeg'].include?(name)   then 
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/#{params[:productname].parameterize}_#{params[:product_id]}(3).#{name}"
						File.open(@path, "wb") { |f| f.write(params[:upload3][:file].read) }
						image = MiniMagick::Image.open(@path)
		                @user_name="#{session[:master_user_id]}";
		                @product_name_3="#{params[:productname].parameterize}_#{params[:product_id]}(3).#{name}"
		                image.resize "200x200"
		                image.write(Rails.root.join('public', 'images',@user_name,'thumb' ,@product_name_3))
		                @path3 = "/images/#{session[:master_user_id]}/"							
						Masterusers.find_by_sql(["UPDATE product_"+session[:master_user_id].to_s+" SET image_3 = ? ,image_name_3 = ? WHERE product_id =?", @path3,@product_name_3, params[:product_id] ])
					else
						flash[:upload] = "#{'only GIF , PNG , JPG , JPEG   then  file formates allowed '}"
					end
					

				end


			redirect_to :action => 'product_view'
			end		
	end


	end
def basic_details
		    @post = Masterusers.find_by_master_user_id(session[:master_user_id])
			if params[:shop_details] == "Submit"
							Masterusers.find_by_sql(["UPDATE masterusers SET shop_name = ? ,address= ?,city = ?,landmark = ?,pincode = ?,phone = ?,state= ? ,country=? WHERE master_user_id = ? ",params[:shopname],params[:address],params[:city],params[:landmark],params[:pincode],params[:phone],params[:state],params[:Country],session[:master_user_id]])

				
			end
			if params[:theme_details]== "Submit"
				Masterusers.find_by_sql(["UPDATE masterusers SET theam = ? WHERE master_user_id = ? ",params[:theme],session[:master_user_id]])
				flash[:notice] = "#{'Theme updated sucessfully'}"
				 	
			end
			if params[:image_details]== "Submit"
				
				if !params[:upload1].blank?
					
					name = params[:upload1][:file].original_filename
					name=name.split(".").last
					 if @test=['gif','png','jpg','jpeg'].include?(name)   then 
						if !@post[:slide_1].nil?
							if File.exist?( Rails.root.join('public', 'images',"#{session[:master_user_id]}","slider_1.#{@post[:slide_1].split(".").last}"))
								File.delete(Rails.root.join('public', 'images',"#{session[:master_user_id]}","slider_1.#{@post[:slide_1].split(".").last}"))
							end
						end
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/slider_1.#{name}"
						File.open(@path, "wb") { |f| f.write(params[:upload1][:file].read) }
						@path1 = "/images/#{session[:master_user_id]}/slider_1.#{name}"
						upload1=true
					else
						upload1=false
					end
				else
					upload1=true
					@path1=@post[:slide_1]
				end	
				if !params[:upload2].blank?
					
					name = params[:upload2][:file].original_filename
					name=name.split(".").last
					if ['gif','png','jpg','jpeg'].include?(name)   then 
						if !@post[:slide_2].nil?
							if File.exist?( Rails.root.join('public', 'images',"#{session[:master_user_id]}","slider_2.#{@post[:slide_2].split(".").last}"))
								File.delete(Rails.root.join('public', 'images',"#{session[:master_user_id]}","slider_2.#{@post[:slide_2].split(".").last}"))
							end
						end						
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/slider_2.#{name}"
						File.open(@path, "wb") { |f| f.write(params[:upload2][:file].read) }
						@path2 = "/images/#{session[:master_user_id]}/slider_2.#{name}"
						upload2=true
					else
						upload2=false
					end
				else
					upload2=true
					@path2=@post[:slide_2]
				end	
				
				if !params[:upload3].blank?
				
					
					name = params[:upload3][:file].original_filename
					name=name.split(".").last
					if ['gif','png','jpg','jpeg'].include?(name)   then 
						if !@post[:slide_3].nil?
							if File.exist?( Rails.root.join('public', 'images',"#{session[:master_user_id]}","slider_3.#{@post[:slide_3].split(".").last}"))
								File.delete(Rails.root.join('public', 'images',"#{session[:master_user_id]}","slider_3.#{@post[:slide_3].split(".").last}"))
							end
						end	
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/slider_3.#{name}"
						File.open(@path, "wb") { |f| f.write(params[:upload3][:file].read) }
						@path3 = "/images/#{session[:master_user_id]}/slider_3.#{name}"
						upload3=true
					else
						upload3=false
					end
				else
					upload3=true
					@path3=@post[:slide_3]
				end	
				
				if upload1==true && upload2==true && upload3==true then 	
						Masterusers.find_by_sql(["UPDATE masterusers SET slide_1=?,slide_2=?,slide_3=? WHERE master_user_id=?",@path1,@path2,@path3,session[:master_user_id]])	
@post = Masterusers.find_by_master_user_id(session[:master_user_id])						
flash[:upload] = "#{'Slider image updated sucessfully'}"
						
					else 
						flash[:upload] = "#{'only GIF , PNG , JPG , JPEG   then  file formates allowed '}"
						
							
					end 
			redirect_to :action=>'basic_detail'

			end
			@post = Masterusers.find_by_master_user_id(session[:master_user_id])
		#	render  'basic_details'
		#	redirect_to :action =>"for_test"
	
	end
def basic_detail

@post = Masterusers.find_by_master_user_id(session[:master_user_id])
render 'basic_details'
end

	
	def authorize 

	#	session[:master_user_id]=session[:master_user_id]=Masterusers.shop_search(request.subdomain);

		$order= Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where read='false' ORDER BY order_id DESC")

		$message= Masterusers.find_by_sql("select * from message_#{session[:master_user_id]} where read='false' ORDER BY message_id DESC")

				

	end

	def test

				$order= Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where read='false' ORDER BY order_id DESC")

				$message= Masterusers.find_by_sql("select * from message_#{session[:master_user_id]} where read='false' ORDER BY message_id DESC")

				#@message=$message

				respond_to do |format|

					format.html # index.html.erb

					format.js   # index.js.erb

					

				end	

	end

	def message

			@message= Masterusers.find_by_sql("select * from message_#{session[:master_user_id]}  ORDER BY message_id DESC")

			 if params[:way]=="notification"

					Masterusers.find_by_sql("update  message_"+session[:master_user_id].to_s+" set read= 'true' where message_id="+params[:id].to_s)

					$message= Masterusers.find_by_sql("select * from message_#{session[:master_user_id]} where read='false' ORDER BY message_id DESC")



			end



        end



	def adminlogin

		if params[:commit] == "login" then
	if request.domain=='startashoppe.com' then 
 		email=	Masterusers.find_by_url_name(request.subdomain).master_email;
        else
		email=Masterusers.find_by_domain_name(request.domain).master_email;
	end
               if  member = Masterusers.find_by_master_email(params[:email]) && email==params[:email]  then 
					 

                               user_details =Masterusers.find_by_master_email(params[:email])

                               if user_details.password ==params[:password] then 

                               session[:master_user_id]= user_details.master_user_id

                              session[:flag]=true;

							  $order= Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where read='false' ORDER BY order_id DESC")

							  $message= Masterusers.find_by_sql("select * from message_#{session[:master_user_id]} where read='false' ORDER BY message_id DESC")

                               redirect_to :action => 'adminhome'

                               else

                               flash[:notice] = "#{'Incorrect Password details'}"        

                                       #render "login"

                                       redirect_to :action => 'adminlogin'

                               end        

                       #redirect_to :controller=>session[:master_user_id], :action => 'home'

                       else

                       flash[:notice] = "#{'Invalid Email address'}"  

						session[:flag]=false;					   

                       #render "login"

                       redirect_to :action => 'adminlogin'

                       end        

               end

       end

	   

	   def add_subcategory

		if session[:flag]==false||session[:flag]==nil then 

			redirect_to :action => 'adminlogin'

		else

			if params[:commit]=="Submit" then 

				test= Masterusers.find_by_sql(["select * from product_sub_category_#{session[:master_user_id]} where product_category_id = ? and sub_category_name= ? " , params[:category_id],params[:c_name]])

				if test=test[0].nil?

				   Masterusers.find_by_sql(["INSERT INTO product_sub_category_"+session[:master_user_id].to_s+"(sub_category_name,product_category_id) VALUES (?,?)",params[:c_name], params[:category_id]])                        

					@flash ="#{params[:c_name]} subcategory Added successfully"

					@ajaxsearch="sucessfull"

					respond_to do |format|

						format.html # index.html.erb

						format.js   # index.js.erb

						format.json { render json:@flash}

						format.json { render json: @ajaxsearch  }

					end

					

				else 

				 # flash[:notice] = "#{params[:c_name]+' Category Name already exist this Subcategory '}"

					@flash="#{params[:c_name]+' subcategory Name already exist this Category '}"

					@ajaxsearch="error"

					respond_to do |format|

						format.html # index.html.erb

						format.js   # index.js.erb

						format.json { render json: @ajaxsearch  }

						format.json { render json:@flash}

					end

				end

				   

			   

		   end

		end

	end

	def adminhome

	
		@p=Masterusers.find_by_sql("SELECT total(total_amt) AS TOTAL_PRICE FROM order_#{session[:master_user_id]}")
		@o=Masterusers.find_by_sql("SELECT COUNT(*) AS AA FROM order_#{session[:master_user_id]} WHERE order_status ='Pending' ")

		if session[:flag]==false||session[:flag]==nil then 

			redirect_to :action => 'adminlogin'

		else

			session[:adminflag] == "true"

			

		end

	end



	def add_category

	

		if session[:flag]==false||session[:flag]==nil then 

			redirect_to :action => 'adminlogin'

		else

			if params[:commit]=="submit" then

				test= Masterusers.find_by_sql(["select * from product_category_"+session[:master_user_id].to_s+ " where product_category_name = ? ", params[:c_name]])

				if test[0].nil?

					Masterusers.find_by_sql(["INSERT INTO product_category_"+session[:master_user_id].to_s+"(product_category_name) VALUES (?)",params[:c_name]])			

					@category =Masterusers.find_by_sql("select * from product_category_#{session[:master_user_id]}")

					@flash ="#{params[:c_name]} Category Added successfully"

					@ajaxsearch="sucessfull"

						respond_to do |format|

							format.html # index.html.erb

							format.js   # index.js.erb

							format.json { render json: @category  }

							format.json { render json:@flash}

							format.json { render json: @ajaxsearch  }

						end

				else

					@flash="#{params[:c_name]+'  Category already exist'}"

					@ajaxsearch="error"

					respond_to do |format|

						format.html # index.html.erb

						format.js   # index.js.erb

						format.json { render json: @ajaxsearch  }

						format.json { render json:@flash}

					end

				#flash[:notice] = "#{params[:c_name]+'  Category already exist'}"

				end

			

			end

		end	

	end

	def category_detail

		if session[:flag]==false||session[:flag]==nil then 

			redirect_to :action => 'adminlogin'

		else

			@category = Masterusers.find_by_sql("select * from product_category_"+session[:master_user_id].to_s)

			@sub_category = Masterusers.find_by_sql("select * from product_sub_category_"+session[:master_user_id].to_s)

			

			if params[:value] == "delete_category"

				   Masterusers.find_by_sql(["delete from product_category_"+session[:master_user_id].to_s+" where product_category_id = ? ", params[:product_category_id].to_s])

					 Masterusers.find_by_sql(["delete from product_sub_category_"+session[:master_user_id].to_s+" where product_category_id = ? ", params[:product_category_id].to_s])

				  redirect_to :action => 'category_detail'

		   end

		   

		   if params[:value] == "delete_sub_category"

				   Masterusers.find_by_sql([ "delete from product_sub_category_#{session[:master_user_id]} where sub_category_id = ?" , params[:sub_category_id].to_s ])

				   redirect_to :action => 'category_detail'

		   end

		   

		   if params[:commit] == "save"

		   @test = params[:categoryname]

		   @x = params[:category]

		   Masterusers.find_by_sql(["UPDATE product_category_"+session[:master_user_id].to_s+" SET product_category_name = ? WHERE product_category_id = ? ",params[:categoryname].to_s,params[:category].to_s])

		   redirect_to :action => 'category_detail'

		   end

		   if params[:commit] == "submit"

		   @test = params[:subcategoryname]

		   @x = params[:subcategory]

		   Masterusers.find_by_sql(["UPDATE product_sub_category_"+session[:master_user_id].to_s+" SET sub_category_name = ? WHERE sub_category_id = ? ",params[:subcategoryname].to_s,params[:subcategory].to_s])

		   redirect_to :action => 'category_detail'

		   end

		end  

	end

	def sales

		if session[:flag]==false||session[:flag]==nil then 

			redirect_to :action => 'adminlogin'

		else

			if params[:sale] == "ok"

				@ajaxsearch="filter_by_product"

				if params[:startdate]==nil and params[:enddate]==nil then 

				@sales = Masterusers.find_by_sql(["select * from sales_#{session[:master_user_id]} where product_id =? ", params[:product_id] ] )



				else 

					if params[:startdate]!="" and params[:enddate]!="" then 

								@sales = Masterusers.find_by_sql(["select * from sales_"+session[:master_user_id].to_s+" where (  date BETWEEN  ? and ?) and product_id = ?",params[:startdate],params[:enddate], params[:product_id]] )



					end 

				end 

				

				#@display = Masterusers.find_by_sql("select * from order_"+session[:master_user_id].to_s+" where order_status = 'delivered'")

			respond_to do |format|

					format.html # index.html.erb

					format.js   # index.js.erb

					format.json { render json: @sales  }

					format.json { render json: @ajaxsearch  }

				end

				

			end

			if params[:sales_date_search] == "Go"

				

				@flag = "sales"

				@ajaxsearch="filter_by_date"

				

					if params[:startdate]!="" and params[:enddate]!="" then 

								@sales = Masterusers.find_by_sql(["select * from sales_#{session[:master_user_id]} where  date BETWEEN ? and ? " , params[:startdate] , params[:enddate]  ])



					end 

				respond_to do |format|

					format.html # index.html.erb

					format.js   # index.js.erb

					format.json { render json: @sales  }

					format.json { render json: @ajaxsearch  }

				end

				

			end	

		end

	end

	def inventory

		if session[:flag]==false||session[:flag]==nil then 

			redirect_to :action => 'adminlogin'

		else

			

			if params[:commit] == "submit"

				@flag = "report"

				@ajaxsearch="Inventory_Item_Status"

				@display = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_status = 'Delivered' and delivery_date between ? and ? ",params[:start_date],params[:end_date]])

				respond_to do |format|

					format.html # index.html.erb

					format.js   # index.js.erb

					format.json { render json: @display  }

					format.json { render json: @ajaxsearch  }

					end

				

			end

			

			if params[:commit] == "ok"

				@flag = "status"

				@ajaxsearch="Inventory_Item_Report"

				@name = Masterusers.find_by_sql(["select product_name, product_id, quantity,out_quantity from product_"+session[:master_user_id].to_s+" where product_id = ?",params[:product_id]])

				respond_to do |format|

					format.html # index.html.erb

					format.js   # index.js.erb

					format.json { render json: @name  }

					format.json { render json: @ajaxsearch  }

					end

			end

			 @ajaxsearch=params[:filter];

			

			if @ajaxsearch=="sub_category" then 

				@sub =Masterusers.find_by_sql(["select * from product_sub_category_"+session["master_user_id"].to_s+" where product_category_id= ? ",params[:category_id].to_s])

				

				respond_to do |format|

					format.html # index.html.erb

					format.js   # index.js.erb

					format.json { render json: @sub  }

					format.json { render json: @ajaxsearch  }

					end

			end

			if @ajaxsearch =="product"

			@product =Masterusers.find_by_sql(["select * from product_"+session["master_user_id"].to_s+" where sub_category_id=?",params[:subcategory_id]])

			

				respond_to do |format|

					format.html # index.html.erb

					format.js   # index.js.erb

					format.json { render json: @product  }

					format.json { render json: @ajaxsearch  }

				end

			end

		end

	end

	def add_product
		if session[:flag]==false||session[:flag]==nil then 
			redirect_to :action => 'adminlogin'
		else
			if params[:commit]=="Submit" then 	
				a=Masterusers.find_by_sql("SELECT Max(product_id) FROM product_"+session[:master_user_id].to_s )
				product_id=a[0]['Max(product_id)']
				if !params[:upload1].blank?
					name = params[:upload1][:file].original_filename
					name=name.split(".").last
					if @test=['gif','png','jpg','jpeg'].include?(name)  
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/#{params[:productname].parameterize}_#{product_id}(1).#{name}"
						File.open(@path, "wb") { |f| f.write(params[:upload1][:file].read) }
						image = MiniMagick::Image.open(@path)
						@user_name="#{session[:master_user_id]}";
						@product_name_1="#{params[:productname].parameterize}_#{product_id}(1).#{name}"
						image.resize "200x200"
						image.write(Rails.root.join('public', 'images',@user_name,'thumb' ,@product_name_1))
						@path1 = "/images/#{session[:master_user_id]}/"
						upload1=true
					else
						upload1=false
					end 
				else
					upload1=true
				end	

				if !params[:upload2].blank?
					name = params[:upload2][:file].original_filename
					name=name.split(".").last
					if @test=['gif','png','jpg','jpeg'].include?(name) 
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/#{params[:productname].parameterize}_#{product_id}(2).#{name}"
						 File.open(@path, "wb") { |f| f.write(params[:upload2][:file].read) }
						 image = MiniMagick::Image.open(@path)
						 @user_name="#{session[:master_user_id]}";
						 @product_name_2="#{params[:productname].parameterize}_#{product_id}(2).#{name}"
						 image.resize "200x200"
						 image.write(Rails.root.join('public', 'images',@user_name,'thumb' ,@product_name_2))
						 @path2 = "/images/#{session[:master_user_id]}/"
						 upload2=true
					else
							upload2=false
					end
				else
					upload2=true
				end		
				if !params[:upload3].blank?
					name = params[:upload3][:file].original_filename
					name=name.split(".").last
					if @test=['gif','png','jpg','jpeg'].include?(name) 
						directory = "public/images/"
						@path = "public/images/#{session[:master_user_id]}/#{params[:productname].parameterize}_#{product_id}(3).#{name}"
						File.open(@path, "wb") { |f| f.write(params[:upload3][:file].read) }
						image = MiniMagick::Image.open(@path)
						@user_name="#{session[:master_user_id]}";
						@product_name_3="#{params[:productname].parameterize}_#{product_id}(3).#{name}"
						image.resize "200x200"
						image.write(Rails.root.join('public', 'images',@user_name,'thumb' ,@product_name_3))
						@path3 = "/images/#{session[:master_user_id]}/"
						upload3=true
					else
						upload3=false
					end
				else
					upload3=true
				end	
				if upload1==true && upload2==true && upload3==true then 	
					Masterusers.find_by_sql(["INSERT INTO product_"+session[:master_user_id].to_s+"(product_name,product_category_id,sub_category_id,quantity,sale_price,price,title,description,image_1,image_2,image_3,shipping,comment,image_name_1,image_name_2,image_name_3) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",params[:productname],params[:category_id],params[:subcategory_id].to_s,params[:quantity],params[:saleprice],params[:price],params[:title],params[:description],@path1,@path2,@path3,'shipping','comment',@product_name_1,@product_name_2,@product_name_3])			
					flash[:notice] = "#{'Product Added Sucessfully now add another product'}"
				else 
	#				@sub = Masterusers.find_by_sql("select * from product_sub_category_"+session["master_user_id"].to_s+" where product_category_id='"+params[:category_id].to_s+"'")
					flash[:notice] = "#{'only GIF , PNG , JPG , JPEG   then  file formates allowed '}"
				end 

			end
			@sub = Masterusers.find_by_sql("select * from product_sub_category_"+session["master_user_id"].to_s+" where product_category_id='"+params[:category_id].to_s+"'")
			respond_to do |format|
				format.html # index.html.erb
				format.js   # index.js.erb
				format.json { render json: @sub  }
			end
		end	
	end


	

	def order

		if session[:flag]==false||session[:flag]==nil then 

			redirect_to :action => 'adminlogin'

		else

			@order=Masterusers.find_by_sql("select * from order_"+ session["master_user_id"].to_s + " where order_status != 'Canceled' ORDER BY order_id DESC" )

			if params[:order_status]=="Ready for Dispatch"

				Masterusers.find_by_sql(["update  order_"+session[:master_user_id].to_s+" set order_status= 'Ready for Dispatch' where order_id=?",params[:order_id].to_s])

				

			end

			if params[:way]=="notification"

				Masterusers.find_by_sql(["update  order_"+session[:master_user_id].to_s+" set read= 'true' where order_id= ? ",params[:id].to_s])

			 $order= Masterusers.find_by_sql("select * from order_1 where read='false' ORDER BY order_id DESC")

				

			end

			

			if params[:order_status]=="Dispatch"

				Masterusers.find_by_sql(["update  order_"+session[:master_user_id].to_s+" set order_status= 'Dispatch' where order_id= ?",params[:order_id].to_s])

			end

			

			if params[:filter]=="Mark as Dispatch"

				Masterusers.find_by_sql(["update  order_"+session[:master_user_id].to_s+" set order_status= 'Dispatch' where order_id= ? ",params[:order_id].to_s])

			end

			if params[:order_status]=="Pending"

				Masterusers.find_by_sql(["update  order_"+session[:master_user_id].to_s+" set order_status= 'Pending' where order_id= ? ", params[:order_id].to_s])

			end

			if params[:order_status]=="Delivered"

						   Masterusers.find_by_sql(["update  order_"+session[:master_user_id].to_s+" set order_status= 'Delivered',delivery_date='"+ Time.now.strftime("%m/%d/%Y") + "' where order_id= ? ",params[:order_id].to_s])

						   @x1= Masterusers.find_by_sql(["select product_id from order_"+session[:master_user_id].to_s+" where order_id = ? ",params[:order_id].to_s])

						   @p = @x1[0]['product_id'].split(" ")

						   @p.each do |a|			

							b=a.split("-")

							@a=b[0]

							out = Masterusers.find_by_sql(["select out_quantity from product_"+session[:master_user_id].to_s+" where product_id = ?", b[0]])

							out = out[0]['out_quantity'] - b[1].to_i

							Masterusers.find_by_sql(["update product_"+session[:master_user_id].to_s+" set out_quantity = ? where product_id = ?",out,b[0]])

							end

			 end

			 if params[:commit]=="submit"

			 Masterusers.find_by_sql(["update  order_"+session[:master_user_id].to_s+" set canceled= 'true',order_status='Canceled',canceled_reason= ? '"+  +"' where order_id= ?", params[:reason], params[:order_id].to_s])

				MasterMailer.Order_canceled(@order[0]['email'],@order[0]['product_id'],session[:master_user_id],params[:reason]).deliver		

			

			end

			if params[:filter]=="all"

			#@test=params[:filter_order_id]

			@order = Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} ORDER BY order_id DESC")

			end

			if params[:filter]=="cod"

			#@test=params[:filter_order_id]

			@order = Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where order_status = 'cod' ORDER BY order_id DESC")

			

			end

			if params[:filter]=="canceled"

			#@test=params[:filter_order_id]

			@order = Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where canceled='true' ORDER BY order_id DESC")

			end

			if params[:filter]=="delivered"

			#@test=params[:filter_order_id]

			@order = Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where order_status = 'Delivered' ORDER BY order_id DESC")

			end

			if params[:filter]=="pending"

			#@test=params[:filter_order_id]

				@order = Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where order_status = 'Pending' ORDER BY order_id DESC")

			end

			if params[:filter]=="rod"

			#@test=params[:filter_order_id]

			@order = Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where order_status = 'Ready for Dispatch' ORDER BY order_id DESC")

			end

			if params[:filter]=="shipped"

			#@test=params[:filter_order_id]

			@order = Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where order_status = 'Dispatch' ORDER BY order_id DESC")

			end

			if params[:filter]=="epr"

			#@test=params[:filter_order_id]
			
			@order = Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where order_status = 'ok' ORDER BY order_id DESC")

			end

		

		

			

			if params[:order_date_search]=="Go"

			

			@order = Masterusers.find_by_sql(["select * from order_#{session[:master_user_id]} where order_date  BETWEEN ? AND ? ORDER BY order_id DESC",params[:startdate],params[:enddate]])

			end		

			if params[:search_mode]=="filter_order_id"

			#@test=params[:filter_order_id]

			

			@order = Masterusers.find_by_sql(["select * from order_#{session[:master_user_id]} where order_id = ? ORDER BY order_id DESC", params[:filter_order_id]])

			end

			

			if params[:search_mode]=="filter_customer"

			

			@order = Masterusers.find_by_sql(["select * from order_#{session[:master_user_id]} where name = ? ORDER BY order_id DESC",params[:filter_order_id]])

			end

			if params[:search_mode]=="filter_payment_mode"

			end

			if params[:search_mode]=="filter_courier_company"

			end

			if params[:search_mode]=="filter_awb_number"

			end

			if params[:g] == 'order_detail'

				#@products = Masterusers.find_by_sql(["select product_id from order_"+session[:master_user_id].to_s+" where order_id = "+params[:id]])

				Masterusers.find_by_sql(["update order_#{session[:master_user_id]} set read='true' where order_id = ? ",params[:id]])

				@x = Masterusers.find_by_sql(["select * from order_"+session[:master_user_id].to_s+" where order_id = ?",params[:id]])

				@x=@x[0]

				c=@x["product_id"].split(" ")

				@p=c

				@a=@x['product_id'].split(/[-]+[\d]*[\s]*/)

				@jsflag='order_detail'

				

			end

			

			respond_to do |format|

			format.html # index.html.erb

			format.js   # index.js.erb

			format.json { render json: @x  }

			format.json { render json: @p  }

			format.json { render json: @a  }

			format.json { render json: @jsflag  }

			end

			

		end	

		

	end

	

	def customer_detail

	#@a = params[:sub_user_id]

	if session[:flag]==false||session[:flag]==nil then 

		redirect_to :action => 'adminlogin'

	else

		if params[:value] == "delete"

			Masterusers.find_by_sql(["delete from sub_users"+session[:master_user_id].to_s+" where sub_user_id = "+params[:sub_user_id].to_s])

			

		end

		

	end	

		

		

	end

	def admin_logout

			
				#session[:master_user_id] = 0
				session[:flag] = false;
				session[:adminflag] = "false"

				redirect_to  :action => 'adminlogin'

			

		end



end
