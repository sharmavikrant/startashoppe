ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :domain => 'railscast.com',
  :user_name => 'vikrantmetawing@gmail.com',
  :password => '9899733143',
  :enable_starttls_auto => true
}


