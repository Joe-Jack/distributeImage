ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: 'masashi.japan@gmail.com',
  password: 'JoeJack5551google',
  authentication: 'plain',
  enable_starttls_auto: true
}