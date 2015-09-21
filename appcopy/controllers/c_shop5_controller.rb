class CShop5Controller < ApplicationController
def contact
	if params[:submit]=='Send Message' then 
				   Masterusers.find_by_sql(["INSERT INTO message_"+session[:master_user_id].to_s+"(name,email,phone,message,read) VALUES (?,?,?,?,?)",params[:name], params[:email],params[:phone],params[:message],'false'])                        
	end 
end

	def create
       

                 image = MiniMagick::Image.open("/assets/images/3.jpg")
image.resize "100x100"
image.write  "output.jpg"
       end


def contact
end
def product_detail
	session[:master_user_id]=Masterusers.shop_search(request.subdomain);

	
	

		if cookies[:recently_view].nil? then 
		cookies[:recently_view]=""
		end
		 if cookies[:recently_view].index(params[:product]) == nil then 
		
		
				#session[:cart]=  session[:cart] + params[:p_id].to_s + " " 
				#cookies[:cart_value]= { :value => session[:cart], :expires => 1.month.from_now};
				cookies[:recently_view]=params[:product].to_s+" "+ cookies[:recently_view].to_s
		else

		cookies[:recently_view]=cookies[:recently_view].delete( params[:product].to_s)
		cookies[:recently_view]=cookies[:recently_view].squish
		cookies[:recently_view]=params[:product].to_s+" "+ cookies[:recently_view].to_s
		end	



		@d=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where product_id = "+params[:product].to_s)
	
	if params[:name]=="detail" then 
		@d=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where product_id = "+params[:product].to_s)
	end
end

def view_all
	session[:master_user_id]=Masterusers.shop_search(request.subdomain);
	@controller=params[:controller]
	 @category=Masterusers.find_by_sql("select * from product_category_#{session[:master_user_id]} " )
                @sub_category=Masterusers.find_by_sql("select * from product_sub_category_#{session[:master_user_id]} " )
	@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s )
	if params[:name] == "search"

		@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where product_category_id = "+params[:category_id])

	end
	if params[:name] == "sub"

		@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where sub_category_id = "+params[:sub_category_id].to_s)

	end
end

def add_to_cart
	session[:master_user_id]=Masterusers.shop_search(request.subdomain);


	if params[:commit] == "payment" then
	 redirect_to :action => 'payment',:total=>params[:total]
	end
	if params[:commit]=="add to cart" then 
		if cookies[:cart_value].nil? then 
			cookies[:cart_value]="";
		end
		cart1=cookies[:cart_value].split(' ')
		 if  @q=cart1.find { |e| /#{params[:p_id]}+[-]+[\d]*/ =~ e }==nil then 
				cart =cookies[:cart_value]
				cart=  params[:p_id].to_s + "-"+params[:quantity].to_s + " " + cart  
				cookies[:cart_value]= { :value => cart, :expires => 15.day.from_now};
				cookies[:cart_valulie]=cookies[:cart_value].squish
				if !cookies[:cart_value].nil? then 
					@p=cookies[:cart_value].split(" ")
					@a=cookies[:cart_value].split(/[-]+[\d]*[\s]*/)
				end
		else
		cookies[:cart_value].gsub!(/#{params[:p_id]}+[-]+[\d]*/, ' ')
		cart =cookies[:cart_value]
				cart=  params[:p_id].to_s + "-"+params[:quantity].to_s + " " + cart  
				cookies[:cart_value]= { :value => cart, :expires => 15.day.from_now};
				cookies[:cart_value]=cookies[:cart_value].squish
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

end



