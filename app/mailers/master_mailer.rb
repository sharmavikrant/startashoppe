class MasterMailer < ActionMailer::Base
  default from: "vikrantmetawing@gmail.com"
  def master_welcome_email(name,email)
	
	@name=name
	
	#@link="http://localhost:3000/real/master_user_validate?method=post&name=0&uid="+id.to_s
	@link="abc"

	
   
    mail(:to => email, :subject => "Welcome to Realestate Site")
  end
   def Order_canceled(email,products,id,reason)
	@reason=reason
	@id=id
	
	#@products = Masterusers.find_by_sql("select product_id from order_"+id.to_s+" where order_id =1")
			c=products.split(" ")
			@a=products.split(/[-]+[\d]*[\s]*/)
			@p=c
	
   
    mail(:to => email, :subject => "Order Cancled")
  end
  
end
