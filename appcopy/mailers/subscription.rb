class Subscription < ActionMailer::Base
  default from: "sharmavikrant14@gmail.com"


  def sub_email(name,address,email,phone)
	@name = name
	@address = address
	@email = email
	@phone = phone
    	@user = "sharmavikrant14@gmail.com"

    mail(to: @user, subject: 'Welcome to My Awesome Site')

  end
end

