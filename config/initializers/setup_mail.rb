ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "startashoppe.com@gmail.com",
  :password             => "metawing",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
