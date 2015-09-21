class CShopController < ApplicationController
def edit_mode_theme

@th = params[:th]

end

def a

end
def test  
#    session[:master_user_id]=Masterusers.shop_search(request.subdomain);
FirstMailer.welcome.deliver

#@user_details=Masterusers.find_by_sql("select * from masterusers where url_name= 'testing'")
 
#UserMailer.welcome_mail(@user_details[0]).deliver
end
def paymentsucess
	session[:master_user_id]=Masterusers.shop_search(request.subdomain);
		Masterusers.find_by_sql(["UPDATE order_#{session[:master_user_id]} SET mihpayid =?,mode=?,payment_status=?,gatway_recived_amount=?,payment_recived_date=?,pg_type=?,bank_ref_num=?,cardnum=? WHERE order_id=?",params[:mihpayid],params[:mode],params[:status],params[:amount],params[:addedon],params[:PG_TYPE],params[:bank_ref_num],params[:cardnum],params[:txnid]])
		@order=Masterusers.find_by_sql("select * from  order_#{session[:master_user_id]} where order_id=#{params[:txnid]}")
		#@order=Masterusers.find_by_sql("select * from  order_37 where order_id=12")
		@p=@order[0][:product_id].split(" ")
		@a=@order[0][:product_id].split(/[-]+[\d]*[\s]*/)
	end
def payment
	session[:master_user_id]=Masterusers.shop_search(request.subdomain);
	@p=cookies[:cart_value].split(" ")
				@a=cookies[:cart_value].split(/[-]+[\d]*[\s]*/)
	if params[:commit] == "payment" then
		
		@test=Masterusers.find_by_sql("select count() from sub_users_#{session[:master_user_id]}  where email='#{params[:email]}'")
		
		if @test[0]['count()']==0 then 
			Masterusers.find_by_sql(["INSERT INTO sub_users_#{session[:master_user_id]}(  name ,address ,pincode ,state,city,land_mark,country,phone,email) VALUES (?,?,?,?,?,?,?,?,?)",params[:name],params[:address],params[:pincode],params[:state],params[:city],params[:landmark],params[:country],params[:phone],params[:email]])				
			@a=Masterusers.find_by_sql("SELECT sub_user_id FROM sub_users_#{session[:master_user_id]} where email='#{params[:email]}'" )
			customer_id=@a[0]['sub_user_id']
		else 
			@a=Masterusers.find_by_sql("SELECT sub_user_id FROM sub_users_#{session[:master_user_id]} where email='#{params[:email]}'" )
			customer_id=@a[0]['sub_user_id']
						
		
		end
		#insert form value in order table 
			Masterusers.find_by_sql(["INSERT INTO order_"+session[:master_user_id].to_s+"(product_id ,customer_id ,name ,address ,pincode ,state,city,land_mark,country,phone,email,total_amt,cod_confirm,order_date,payment_mode,payment_status,order_status,canceled) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",cookies[:cart_value],customer_id,params[:name],params[:address],params[:pincode],params[:state],params[:city],params[:land_mark],params[:country],params[:phone],params[:email],params[:total],"false",Time.now.strftime("%m/%d/%Y"),"cod","Pending","Pending","false"])				
		#end
		#select maximum order id from order table 
			@a=Masterusers.find_by_sql("SELECT Max(order_id) FROM order_"+session[:master_user_id].to_s )
			order_id=@a[0]['Max(order_id)']
			Exotel.configure do |c|
			c.exotel_sid   = "metawingtechnologys"
			c.exotel_token = "5adfe2723e578cc00b06d7a36dfd7dddb1966f7a"
		end
	#	response = Exotel::Sms.send(:from => '01203843107', :to => '9990743686', :body => "Thanks for placing an order.Your order id is #{order_id}")	
	#end
		# calculation for old total,order_id and new total and order id 
			to=Masterusers.find_by_sql("SELECT total, order_id FROM sub_users_#{session[:master_user_id]} where email='#{params[:email]}'" )
			total=to[0]['total'];
			old_order_id=to[0]['order_id'];
			total=total.to_i+params[:total].to_i;
			new_order_id=order_id.to_s+","+old_order_id.to_s
			
		# end of this order id and total calculation 
		#update subusers table for tota and order id	
			Masterusers.find_by_sql("update sub_users_#{session[:master_user_id]} set order_id='#{new_order_id}',last_order_date='#{Time.now.strftime("%m/%d/%Y")}',total=#{total} where email='#{params[:email]}'")
		#end 
		p=cookies[:cart_value].split(" ")
	
		p.each do |a|			
			b=a.split("-")
						
			Masterusers.find_by_sql(["INSERT INTO product_order_"+session[:master_user_id].to_s+"(product_id,order_id,quantity) VALUES (?,?,?)",b[0],order_id,b[1]])					
			@x = Masterusers.find_by_sql("select out_quantity ,quantity,sale_price,product_name from product_"+session[:master_user_id].to_s+" where product_id = "+b[0])					 
			q = @x[0]['quantity'] - b[1].to_i
			out = @x[0]['out_quantity'] + b[1].to_i
			
			product_t_total=@x[0]['sale_price'].to_i*b[1].to_i
			#product_t_total=11100
			
			
			product_name=@x[0]['product_name']
			Masterusers.find_by_sql(["UPDATE product_"+session[:master_user_id].to_s+" SET quantity=?,out_quantity=? WHERE product_id=?",q,out,b[0]])	
			Masterusers.find_by_sql(["INSERT INTO sales_"+session[:master_user_id].to_s+"(product_id ,order_id ,customer_id ,quantity ,date,productname,total) VALUES (?,?,?,?,?,?,?)",b[0],order_id,customer_id,b[1],Time.now.strftime("%m/%d/%Y"),product_name,product_t_total])				
		
		end						
				
	
			cookies.delete :cart_value
			#paymentgatway deatils processing
		require 'digest'
		@details=Masterusers.find_by_sql("select * from order_#{session[:master_user_id]} where order_id=#{order_id}")
		@details=@details[0]
	#	@abc="JBZaLc|@details[:order_id]|@details[:total_amt]|Test Order|@details[:name]|@details[:email]|||||||||||GQs7yium"
		@digest=Digest::SHA512.hexdigest("RV6ahR|#{@details[:order_id]}|#{@details[:total_amt]}|Test Order|#{@details[:name]}|#{@details[:email]}|||||||||||CpqHI3t7")
		#render "paymentgatway"
			#end of payament gatway processing 				
		if session[:theme] == 'theme_10'				
	#	redirect_to :controller => 'c_shop10', :action => 'home'	
		render "paymentgatway"
	else
			#	redirect_to :action => 'home'
			render "paymentgatway"	
	end	
		
	end
			 if !params[:payment]=="details"
			 @user_details=Masterusers.find_by_sql("select * from sub_users_#{session[:master_user_id]} where email='#{params[:name]}'")				
			
				respond_to do |format|
					format.html # index.html.erb
					format.js   # index.js.erb
					format.json { render json: @user_details  }
				
				end	
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
	session[:master_user_id]=Masterusers.shop_search(request.subdomain);

	@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s )
	if params[:name] == "search"

		@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where product_category_id = "+params[:category_id])

	end
	if params[:name] == "sub"

		@product=Masterusers.find_by_sql("select * from product_"+session[:master_user_id].to_s+" where sub_category_id = "+params[:sub_category_id])

	end
end	

def product_detail
session[:master_user_id]=Masterusers.shop_search(request.subdomain);
	
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

		s="CREATE TABLE "+ "product_"+session[:master_user_id].to_s+"(product_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_name varchar(255),product_category_id integer NOT NULL ,sub_category_id integer NOT NULL, price integer NOT NULL, sale_price integer not null, quantity integer NOT NULL,title varchar(255) ,description varchar(2000),image_1 varchar(255),image_name_1 varchar(100),image_2 varchar(255),image_name_2 varchar(100),image_3 varchar(255),image_name_3 varchar(100),shipping boolean ,comment boolean,revised_price integer, out_quantity integer default 0)"
		connection.execute(s)
s="CREATE TABLE message_#{session[:master_user_id]}(message_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , name varchar(255) ,email varchar(255) ,phone varchar(255) ,message varchar(3000),read string )"
		connection.execute(s)

		s="CREATE TABLE "+ "order_"+session[:master_user_id].to_s+"(order_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_id varchar(255),customer_id integer,name varchar(255),address varchar(255),pincode varchar(255),state varchar(255),city varchar(255),land_mark varchar(255),country varchar(255),phone varchar(255),email varchar(255),date datetime, order_date datetime, total_amt integer, delivery_date date, cod_confirm varchar(255),payment_mode varchar(255),payment_status varchar(255),order_status varchar(255),canceled boolean,canceled_reason varchar(1000),read varchar(1000))"
		connection.execute(s)

		s="CREATE TABLE "+ "customer_"+session[:master_user_id].to_s+"(customer_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , user_name varchar(255),password varchar(255),first_name varchar(255),last_name varchar(255), address varchar(255), city varchar(255), state varchar(255), pincode varchar(255), country varchar(255),phone varchar(255), order_id varchar(255))"
		connection.execute(s)

		s="CREATE TABLE "+ "product_category_"+session[:master_user_id].to_s+"(product_category_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_category_name varchar(255) not null UNIQUE )"
		connection.execute(s)
		s="CREATE TABLE "+ "product_order_"+session[:master_user_id].to_s+"(product_id INTEGER , order_id INTEGER,quantity varchar(255))"
		connection.execute(s)
		s="CREATE TABLE "+ "product_sub_category_"+session[:master_user_id].to_s+"(product_category_id integer NOT NULL, sub_category_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,sub_category_name varchar(255))"

		connection.execute(s)
			s="	CREATE TABLE sub_users_#{session[:master_user_id]}(sub_user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,order_id integer,name varchar(255),address varchar(255),pincode varchar(255),state varchar(255),city varchar(255),land_mark varchar(255),country varchar(255),phone varchar(255),email varchar(255),last_order_date datetime,proceed_so_far datetime,total integer,password varchar(50) )"
		connection.execute(s)
		s="CREATE TABLE sales_#{session[:master_user_id]}(sale_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,order_id integer,customer_id integer,product_id integer,quantity integer ,productname varchar(100),total integer,date datetime)"		
		connection.execute(s)
		s="CREATE TABLE "+ "subuser_"+session[:master_user_id].to_s+"(sub_user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,first_name varchar(255),last_name varchar(255),address varchar(255),city varchar(255),state varchar(255),pincode varchar(255),country varchar(255),phone varchar(255),subuser_email varchar(255),password varchar(255),order_id integer)"
		#s="CREATE TABLE "+ "product_details_"+session[:master_user_id].to_s+"(product_id int NOT NULL , title varchar(255) ,description varchar(2000),image_1 varchar(255),image_2 varchar(255),image_3 varchar(255),shipping boolean ,allow_comment boolean)"
		#connection.execute(s)
		Masterusers.find_by_sql(["INSERT INTO product_category_"+session[:master_user_id].to_s+"(product_category_name) VALUES (?)","Demo Category"])			
			Masterusers.find_by_sql(["INSERT INTO product_sub_category_"+session[:master_user_id].to_s+"(sub_category_name,product_category_id) VALUES (?,?)","Demo Sub Category", 1])                    
			
s="INSERT INTO product_#{session[:master_user_id]}(product_name,product_category_id,sub_category_id,quantity,sale_price,price,title,description,image_1,image_2,image_3,shipping,comment,image_name_1,image_name_2,image_name_3) VALUES ('Demo',1,1,5,200,500,'Demo Product','description of this product will show here','/images/','/images/','/images/','true','true','Demo-Product.jpg','Demo-Product.jpg','Demo-Product.jpg')"			
		connection.execute(s)
		connection.execute(s)
		connection.execute(s)
		connection.execute(s)
	Masterusers.find_by_sql("update masterusers set slide_1='/images/slide1.jpg',slide_2='/images/slide1.jpg',slide_3='/images/slide1.jpg' where master_user_id=#{session[:master_user_id]}");			
			
		unless File.directory?("public/images/#{session[:master_user_id]}")
				Dir.mkdir"public/images/#{session[:master_user_id]}"
			end

		 unless File.directory?("public/images/#{session[:master_user_id]}/thumb")
                                Dir.mkdir"public/images/#{session[:master_user_id]}/thumb"
                        end
		s="select * from masterusers where master_user_id= #{session[:master_user_id]} "
		user=Masterusers.find_by_sql(s);
	#	UserMailer.welcome_mail(user[0]).deliver
		redirect_to :controller=>'first', :action => 'c_step_2'
end 

def fst 
end


def home 
#session[:master_user_id]=Masterusers.shop_search(request.subdomain);

		@t=Masterusers.all
		@theme=session[:theme]
		t=Masterusers.find_by_master_user_id(session[:master_user_id])
		 session[:shop_name]=t['shop_name']
 session[:url_name]=t['url_name']
         @address=t['address']
         @master_email=t['master_email']
         @phone=t['phone']
 
		if params[:name]=="createstore"
		redirect_to :action => 'c_step_2'
		end
		
		if params[:name] == "edit"
			session[:mode]="edit"
		end	

		if params[:commit] == "visit site"
			session[:mode]="abc"
		end
end

def editmode
session[:master_user_id]=Masterusers.shop_search(request.subdomain);

	if params[:commit] == "slider_1"
		if !params[:upload1].blank?
			name = params[:upload1][:file1].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/slider_1.#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload1][:file1].read) }
			
			@path1 = "/images/#{session[:master_user_id]}/slider_1.#{name}"
		end	
		Masterusers.find_by_sql(["UPDATE masterusers SET slide_1 =? WHERE master_user_id=?",@path1,session[:master_user_id]])	
	end
	if params[:commit] == "slider_2"
		if !params[:upload2].blank?
			name = params[:upload2][:file2].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/slider_2.#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload2][:file2].read) }
			
			@path1 = "/images/#{session[:master_user_id]}/slider_2.#{name}"
		end	
		Masterusers.find_by_sql(["UPDATE masterusers SET slide_2 =? WHERE master_user_id=?",@path1,session[:master_user_id]])	
	end
	if params[:commit] == "slider_3"
		if !params[:upload3].blank?
			name = params[:upload3][:file3].original_filename
			name=name.split(".").last
			directory = "public/images/"
			@path = "public/images/#{session[:master_user_id]}/slider_3.#{name}"
			File.open(@path, "wb") { |f| f.write(params[:upload3][:file3].read) }
			
			@path1 = "/images/#{session[:master_user_id]}/slider_3.#{name}"
		end	
		Masterusers.find_by_sql(["UPDATE masterusers SET slide_3 =? WHERE master_user_id=?",@path1,session[:master_user_id]])	
	end
	redirect_to :action => 'home'

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
       
				
		if request.domain == "startashoppe.com" then 
            	   if (!Masterusers.find_by_url_name(request.subdomain).nil?) then 
                       @t=Masterusers.find_by_url_name(request.subdomain)
                       session[:theme]=@t.theam
			   session[:master_user_id]=@t.master_user_id
			if session[:theme] == "theme_10"
                               redirect_to :controller=> 'c_shop10', :action => 'home'
                	 else
                               redirect_to :action => 'home'
                        end


             	  else
				redirect_to :action => 'error'
              	 end
		else
				@t=Masterusers.find_by_domain_name(request.domain)
				session[:theme]=@t.theam
				session[:master_user_id]=@t.master_user_id
        
				redirect_to :action => 'home'
	end			   
	end
	def create_shop
					if params[:name]== "ok" then
						@t=Masterusers.find_by_master_user_id(session[:master_user_id])
                       session[:theme]=@t.theam
					    session[:master_user_id]=@t.master_user_id
						redirect_to :action => 'create_store',:ok=>"ok"         
					end
	
              
       
	end
	def error 
	
	end
	
	  
	
end
