require 'action_mailer'

ActionMailer::Base.smtp_settings = {
  :address        		=> 'mail.vosto.co.za', # default: localhost
  :port           		=> '25',                  # default: 25
  :domain         		=> 'vosto.co.za',
  :user_name      		=> 'info@vosto.co.za',
  :password      		=> 'R@d6hi@..',
  :authentication       => "plain",       # :plain, :login or :cram_md5
  :enable_starttls_auto => true,
  :openssl_verify_mode  => 'none'              
}

ActionMailer::Base.view_paths = Dir[File.dirname(__FILE__) + '/app/views/']