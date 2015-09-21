class FirstMailer < ActionMailer::Base
  default from: "startashoppe.com@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.first_mailer.welcome.subject
  #
def welcome(url,shopname,email,password)
	@url = url
	@shopname = shopname
	@email = email
	@password= password
  mail(:to =>@email, :subject => "Some one wnat to contact us ")
#    mail to: "sharmavikrant14@gmail.com"
  end
end
