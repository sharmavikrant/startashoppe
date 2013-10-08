class CShopController < ApplicationController
def a

end
def test  
end
def payment
connection = ActiveRecord::Base.connection();
	
	if params[:commit] == "payment" then
		Masterusers.find_by_sql(["INSERT INTO order_"+session[:master_user_id].to_s+"(product_id ,customer_id ,name ,address ,pincode ,state,city,land_mark,country,phone,email,total_amt,cod_confirm,order_date,payment_mode,payment_status,order_status,canceled) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",cookies[:cart_value],session[:master_user_id],params[:name],params[:address],params[:pincode],params[:state],params[:city],params[:land_mark],params[:country],params[:phone],params[:email],session[:t],"false",Time.now.strftime("%m/%d/%Y"),"cod","panding","panding","false"])		
		@a=Masterusers.find_by_sql("SELECT Max(order_id) FROM order_"+session[:master_user_id].to_s )
		order_id=@a[0]['Max(order_id)']
		p=cookies[:cart_value].split(" ")
	
		p.each do |a|			
			b=a.split("-")
						
			Masterusers.find_by_sql(["INSERT INTO product_order_"+session[:master_user_id].to_s+"(product_id,order_id,quantity) VALUES (?,?,?)",b[0],order_id,b[1]])					
			@x = Masterusers.find_by_sql("select out_quantity ,quantity from product_"+session[:master_user_id].to_s+" where product_id = "+b[0])					 
			q = @x[0]['quantity'] - b[1].to_i
			out = @x[0]['out_quantity'] + b[1].to_i
			Masterusers.find_by_sql(["UPDATE product_"+session[:master_user_id].to_s+" SET quantity=?,out_quantity=? WHERE product_id=?",q,out,b[0]])	

		end						
				
	
			cookies.delete :cart_value				
			
	end
end

def add_to_cart

	if params[:commit] == "payment" then
	 redirect_to :action => 'payment'
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
				cookies[:cart_value]=cookies[:cart_value].squish
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
def view_all_products
	@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s )
	if params[:name] == "search"

		@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where product_category_id = "+params[:category_id])

	end
	if params[:name] == "sub"

		@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where sub_category_id = "+params[:sub_category_id])

	end
end	

def product_detail
	
	@p=params[:order_search_field]
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
				
			
		
	
	
		@d=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where product_id = "+params[:product])
	
		
	
end
def create_store

		connection = ActiveRecord::Base.connection();

		s="CREATE TABLE "+ "product_"+session[:master_user_id].to_s+"(product_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_name varchar(255),product_category_id integer NOT NULL ,sub_category_id integer NOT NULL, price integer NOT NULL, sale_price integer not null, quantity integer NOT NULL,title varchar(255) ,description varchar(2000),image_1 varchar(255),image_2 varchar(255),image_3 varchar(255),shipping boolean ,comment boolean,revised_price integer, out_quantity integer default 0)"
		connection.execute(s)

		s="CREATE TABLE "+ "order_"+session[:master_user_id].to_s+"(order_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_id varchar(255),customer_id integer,name varchar(255),address varchar(255),pincode varchar(255),state varchar(255),city varchar(255),land_mark varchar(255),country varchar(255),phone varchar(255),email varchar(255),order_date datetime, total_amt integer, delivery_date date, cod_confirm varchar(255),payment_mode varchar(255),payment_status varchar(255),order_status varchar(255),canceled boolean,canceled_reason varchar(1000))"
		connection.execute(s)

		s="CREATE TABLE "+ "customer_"+session[:master_user_id].to_s+"(customer_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , user_name varchar(255),password varchar(255),first_name varchar(255),last_name varchar(255), address varchar(255), city varchar(255), state varchar(255), pincode varchar(255), country varchar(255),phone varchar(255), order_id varchar(255))"
		connection.execute(s)

		s="CREATE TABLE "+ "product_category_"+session[:master_user_id].to_s+"(product_category_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_category_name varchar(255) not null UNIQUE )"
		connection.execute(s)
		s="CREATE TABLE "+ "product_order_"+session[:master_user_id].to_s+"(product_id INTEGER , order_id INTEGER,quantity varchar(255))"
		connection.execute(s)
		s="CREATE TABLE "+ "product_sub_category_"+session[:master_user_id].to_s+"(product_category_id integer NOT NULL, sub_category_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,sub_category_name varchar(255))"

		connection.execute(s)
		s="CREATE TABLE "+ "subuser_"+session[:master_user_id].to_s+"(sub_user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,first_name varchar(255),last_name varchar(255),address varchar(255),city varchar(255),state varchar(255),pincode varchar(255),country varchar(255),phone varchar(255),subuser_email varchar(255),password varchar(255),order_id integer)"
		#s="CREATE TABLE "+ "product_details_"+session[:master_user_id].to_s+"(product_id int NOT NULL , title varchar(255) ,description varchar(2000),image_1 varchar(255),image_2 varchar(255),image_3 varchar(255),shipping boolean ,allow_comment boolean)"
		#connection.execute(s)
		unless File.directory?("public/images/#{session[:master_user_id]}")
				Dir.mkdir"public/images/#{session[:master_user_id]}"
			end
		redirect_to :action => 'home',:name=>"createstore"
end 

def fst 
end


def home 
		@t=Masterusers.all
		@theme=session[:theme]
		t=Masterusers.find_by_master_user_id(session[:master_user_id])
		 session[:shop_name]=t['shop_name']
         @address=t['address']
         @master_email=t['master_email']
         @phone=t['phone']
 
		if params[:name]=="createstore"
		redirect_to :action => 'c_step_2'
		end
		
		
		
		

end
def master_signup 
		begin 
			if params[:commit] == "upload" then
				if params[:name] ==''  then 
				flash[:notice] = "#{'shop name is mandatory'}"
			redirect_to :action=>'fst'
				else
					Masterusers.create(:url_name => params[:name])
					# Mastermailer.master_welcome_email( a,params[:name],params[:email]).deliver
					MasterMailer.master_welcome_email(params[:name],params[:email]).deliver
					session[:master_user_id]=(Masterusers.last).master_user_id	 
					redirect_to :action => 'c_step_2'
				end
			end
		rescue => e 	
			flash[:notice] = "#{'Shop URL must be unique "'+ params[:name] +e.message+'" this URL already exist'}"
			redirect_to :action=>'fst'
		end
				
	end
	def shop_search_2
	if (!Masterusers.find_by_url_name(request.subdomain).nil?) then 
                       @t=Masterusers.find_by_url_name(request.subdomain)
                       session[:theme]=@t.theam
					   session[:master_user_id]=@t.master_user_id
                       redirect_to :controller=>'admin_home',:action => 'adminhome'
	end
	end
	def shop_search
       session[:theme]="abc"
               if (!Masterusers.find_by_url_name(request.subdomain).nil?) then 
                       @t=Masterusers.find_by_url_name(request.subdomain)
                       session[:theme]=@t.theam
					   session[:master_user_id]=@t.master_user_id
                       redirect_to :action => 'home'
               else
					if params[:name]== "ok" then
						@t=Masterusers.find_by_master_user_id(session[:master_user_id])
                       session[:theme]=@t.theam
					    session[:master_user_id]=@t.master_user_id
						redirect_to :action => 'create_store',:ok=>"ok"         
					end
               end
       
	end
	  
	
end
