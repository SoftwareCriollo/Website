class Mailer
  def self.send_lead(source, name, email, phone, description)
    send_mail :to => ENV['EMAIL_TO'],
      :subject => "New Lead: #{email}",
      :html_body => report_template(source, name, email, phone, description),
      :via => :smtp,
      :via_options =>  via_options
  end

  private

  def self.report_template(source, name, email, phone, description)
    haml_template = File.read("views/emails/newlead.haml")
    Haml::Engine.new(haml_template).render(binding, {source: source, name: name, email: email, phone: phone, description: description})
  end

  def self.send_mail hash
    Pony.mail hash
  end

  def self.via_options
    {
      :address => 'smtp.gmail.com',
      :port => '587',
      :enable_starttls_auto => true,
      :user_name => ENV['EMAIL_USER_NAME'], 
      :password => ENV['EMAIL_PASSWORD'],
      :authentication => :plain,
      :domain => ENV['EMAIL_DOMAIN']
    }
  end

end