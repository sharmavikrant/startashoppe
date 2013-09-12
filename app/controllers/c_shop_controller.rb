class CShopController < ApplicationController

	
def fst 
end
def home 

		@t=Masterusers.all
			@theme=session[:theme]
			@shop_name=session[:shop_name]
			@address=session[:address]
			@master_email=session[:master_email]
			@phone=session[:phone]
			
		
		if params[:ok]=="ok"
			@t=Masterusers.all
			@theme=session[:theme]
		end
		
		
		

end
def master_signup 
			if params[:commit] == "upload" then
					
					
						 Masterusers.create(:url_name => params[:name])
						 # Mastermailer.master_welcome_email( a,params[:name],params[:email]).deliver
						 MasterMailer.master_welcome_email(params[:name],params[:email]).deliver
					session[:master_user_id]=(Masterusers.last).master_user_id	 
				
					flash[:notice] = "#{'Your account created successfully and your user id  ='}"
					redirect_to :action => 'c_step_2'
				end
			
	end
	def c_step_1
	
		
			
				Masterusers.find_by_sql(["UPDATE masterusers SET theam =? WHERE master_user_id=?",params[:theme],session[:master_user_id]])	
				
		
	
		redirect_to :action => 'c_step_2'
	end
	
	def c_step_2
	@test=params[:commit]
		if params[:commit]== "Submit" then
			if params[:password] == params[:confirmpassword] then
				Masterusers.find_by_sql(["UPDATE masterusers SET shop_name =?,first_name=?,last_name=?,master_email=?, password=? WHERE master_user_id=?",params[:shopname],params[:firstname],params[:lastname],params[:emailaddress],params[:password],session[:master_user_id]])	
				Masterusers.find_by_sql(["UPDATE masterusers SET last_name=?,master_email=?, password=? WHERE master_user_id=?",params[:lastname],params[:emailaddress],params[:password],session[:master_user_id]])	
			else
			flash[:notice] = "#{'password and confirm password does not match'}"
					redirect_to :action => 'c_step_2'
			end
		end
	
		if params[:commit]== "Submit3" then
			
				Masterusers.find_by_sql(["UPDATE masterusers SET address =?,landmark=?,city=?,state=?, pincode=?,country=?,phone=? WHERE master_user_id=?",params[:address],params[:landmark],params[:city],params[:state],params[:pincode],params[:country],params[:phone],session[:master_user_id]])	
				
			
		end
		
		if params[:value] == "img"
			session[:theme] = params[:t]
			redirect_to :action => 'home'
		end
	end
	def c_step_3
	
	
	
		if params[:commit]== "Submit" then
			
				Masterusers.find_by_sql(["UPDATE masterusers SET address =?,landmark=?,city=?,state=?, pincode=?,country=?,phone=? WHERE master_user_id=?",params[:address],params[:landmark],params[:city],params[:state],params[:pincode],params[:country],params[:phone],session[:master_user_id]])	
				
			
		end
		redirect_to :action => 'c_step_2'
	end
	def shop_search
	session[:theme]="abc"
		if (!Masterusers.find_by_url_name(request.subdomain).nil?) then 
			@t=Masterusers.find_by_url_name(request.subdomain)
			session[:theme]=@t.theam
			session[:shop_name]=@t.shop_name
			session[:address]=@t.address
			session[:master_email]=@t.master_email
			session[:phone]=@t.phone
			redirect_to :action => 'home'
		else
		 if params[:commit]== "ok" then
		 @t=Masterusers.find_by_master_user_id(session[:master_user_id])
			session[:theme]=@t.theam
			 redirect_to :action => 'create_store',:ok=>"ok"         
		end
		end
	
	end
	
	def preview
		@t=Masterusers.all
		@theme=params[:theme]
	end
	
	def create_store

		connection = ActiveRecord::Base.connection();

		s="CREATE TABLE "+ "product_"+session[:master_user_id].to_s+"(product_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_name varchar(255),product_category_id integer NOT NULL ,sub_category_id integer NOT NULL, price integer NOT NULL, sale_price integer not null, quantity integer NOT NULL,title varchar(255) ,description varchar(2000),image_1 varchar(255),image_2 varchar(255),image_3 varchar(255),shipping boolean ,comment boolean)"
		connection.execute(s)

		s="CREATE TABLE "+ "order_"+session[:master_user_id].to_s+"(order_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_id integer NOT NULL,customer_id integer NOT NULL,order_date date, order_time datetime, total_amt integer NOT NULL, deliver_address varchar(255), status varchar(255), delivery_date date, delivery_time datetime)"
		connection.execute(s)

		s="CREATE TABLE "+ "subuser_"+session[:master_user_id].to_s+"(sub_user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , first_name varchar(255),last_name varchar(255), address varchar(255), city varchar(255), state varchar(255), pincode varchar(255), country varchar(255),phone varchar(255),password varchar(255), order_id varchar(255), subuser_email varchar(255) NOT NULL unique )"
		connection.execute(s)

		s="CREATE TABLE "+ "product_category_"+session[:master_user_id].to_s+"(product_category_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , product_category_name varchar(255))"
		connection.execute(s)

		s="CREATE TABLE "+ "product_sub_category_"+session[:master_user_id].to_s+"(product_category_id integer NOT NULL, sub_category_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,sub_category_name varchar(255))"
		connection.execute(s)
		#s="CREATE TABLE "+ "product_details_"+session[:master_user_id].to_s+"(product_id int NOT NULL , title varchar(255) ,description varchar(2000),image_1 varchar(255),image_2 varchar(255),image_3 varchar(255),shipping boolean ,allow_comment boolean)"
		#connection.execute(s)
		redirect_to :action => 'c_step_2'
end 

def view_all_products
end	
	
end