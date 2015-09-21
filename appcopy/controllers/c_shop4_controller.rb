class CShop4Controller < ApplicationController


def contact
	if params[:submit]=='Send Message' then 
				   Masterusers.find_by_sql(["INSERT INTO message_"+session[:master_user_id].to_s+"(name,email,phone,message,read) VALUES (?,?,?,?,?)",params[:name], params[:email],params[:phone],params[:message],'false'])                        
	end 
end


	def product_detail
		 session[:master_user_id]=Masterusers.shop_search(request.subdomain);
		 @controller=params[:controller]

		 @category=Masterusers.find_by_sql("select * from product_category_#{session[:master_user_id]} " )
                @sub_category=Masterusers.find_by_sql("select * from product_sub_category_#{session[:master_user_id]} " )
		if cookies[:recently_view] == nil then 
			cookies[:recently_view]=""
		end
		 if cookies[:recently_view].index(params[:product]) == nil then 
				recently=params[:product].to_s+" "+ cookies[:recently_view].to_s
				cookies[:recently_view]= { :value => recently, :expires => 15.day.from_now};
		else
			recently=cookies[:recently_view].delete( params[:product].to_s)
			recently=recently.squish
			recently=params[:product].to_s+" "+ recently.to_s
			cookies[:recently_view]= { :value => recently, :expires => 15.day.from_now};

		end
		
		
			#@test=Masterusers.find_by_sql("select * from product_#{session[:master_user_id]} where product_id=#{params[:product]}" )
			@product_detail=Masterusers.find_by_sql("select * from product_#{session[:master_user_id]} where product_id=#{params[:product]}" )
			
			@related=Masterusers.find_by_sql("select * from product_#{session[:master_user_id]} where sub_category_id=#{@product_detail[0]['sub_category_id']} ORDER BY product_id DESC LIMIT 8"  )
			
			
  end
  def add_to_cart
	session[:master_user_id]=Masterusers.shop_search(request.subdomain);
	
		if params[:commit] == "payment" then
		 redirect_to :action => 'payment',:total=>params[:total]
		end
		if params[:name]=="add to cart" then 
		@test="testok"
			if cookies[:cart_value].nil? then 
				cookies[:cart_value]="";
			end
			cart1=cookies[:cart_value].split(' ')
			 if  @q=cart1.find { |e| /#{params[:p_id]}+[-]+[\d]*/ =~ e }==nil then 
					cart =cookies[:cart_value]
					cart=  params[:p_id].to_s + "-"+params[:quantity].to_s + " " + cart  
					cookies[:cart_value]= { :value => cart, :expires => 15.day.from_now};
					cookies[:cart_value]={ :value => cookies[:cart_value].squish, :expires => 15.day.from_now};
					if !cookies[:cart_value].nil? then 
						@p=cookies[:cart_value].split(" ")
						@a=cookies[:cart_value].split(/[-]+[\d]*[\s]*/)
					end
			else
			cookies[:cart_value].gsub!(/#{params[:p_id]}+[-]+[\d]*/, ' ')
			cart =cookies[:cart_value]
					cart=  params[:p_id].to_s + "-"+params[:quantity].to_s + " " + cart  
					cookies[:cart_value]= { :value => cart, :expires => 15.day.from_now};
					cookies[:cart_value]={ :value => cookies[:cart_value].squish, :expires => 15.day.from_now};
					if !cookies[:cart_value].nil? then 
						@p=cookies[:cart_value].split(" ")
						@a=cookies[:cart_value].split(/[-]+[\d]*[\s]*/)
					end
			end
			
		end
		if params[:name]=="show_cart"
			if !cookies[:cart_value].nil? then 
				@p=cookies[:cart_value].split(" ")
				@a=cookies[:cart_value].split(/[-]+[\d]*[\s]*/)
				
			end
		end
		
		if params[:name]=="delete"
		
		 
			
			a=cookies[:cart_value].gsub!(/#{params[:p_id]}+[-]+[\d]*/, ' ')
			cookies[:cart_value]= { :value => a, :expires => 15.day.from_now};
		
			if !cookies[:cart_value].nil? then 
				@p=cookies[:cart_value].split(" /#{params[:p_id]}+[-]+[\d]*/")
				@a=cookies[:cart_value].split(/[-]+[\d][\s]*/)
				
			end
		end
		
	end
	def view_all
	 @category=Masterusers.find_by_sql("select * from product_category_#{session[:master_user_id]} " )
                @sub_category=Masterusers.find_by_sql("select * from product_sub_category_#{session[:master_user_id]} " )
	@controller=params[:controller]
	session[:master_user_id]=Masterusers.shop_search(request.subdomain);

	@products=Masterusers.find_by_sql("select * from product_#{session[:master_user_id]} " )
		if params[:filter]=='search' then 
			@products=Masterusers.find_by_sql("select * from product_#{session[:master_user_id]} where product_category_id=#{params[:c_id]} " )

		end
		
		if params[:filter]=='subcategory' then 
		
			@products=Masterusers.find_by_sql("select * from product_#{session[:master_user_id]} where sub_category_id=#{params[:s_id]} " )

		end
	end
end
