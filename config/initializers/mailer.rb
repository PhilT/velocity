ActionMailer::Base.smtp_settings = {
  :address => "mail.authsmtp.com",
  :port => 25,
  :domain => "example.com",
  :user_name => "user",
  :password => "pass",
  :authentication => :plain
}

