class MasterMailer < ActionMailer::Base
  default from: "vikrantmetawing@gmail.com"
  def master_welcome_email(name,email)
	
	@name=name
	
	#@link="http://localhost:3000/real/master_user_validate?method=post&name=0&uid="+id.to_s
	@link="abc"

	
   
    mail(:to => email, :subject => "Welcome to Realestate Site")
  end
  
end
