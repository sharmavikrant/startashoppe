class UserMailer < ActionMailer::Base
  default from: "sharmavikrant1014@gmail.com"
	 def registration_confirmation()
		   # @user = user
		   # attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
		    mail(:to =>"sachinsingh.7903@gmail.com", :subject => "Registered")
	  end
	def welcome_mail(user)
	    @user = user
  
	    mail(:to =>"sharmavikrant1014@gmail.com", :subject => "Registered")
	  end
	 def contact(name,email,comments)

            @user = [name,email,comments]		
         mail(:to =>'startashoppe@gmail.com', :subject => "Some one wnat to contact us ")
          end



end
