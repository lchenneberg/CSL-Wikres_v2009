class Notifier < ActionMailer::Base
  def signup_notification(user)
    recipients    user.email
    from          "no-reply@wikres.net"
    subject       "Votre compte Wikres a été créé"
    body          :user => user,
      :url => "#{ENV["HTTP_HOST"]}/users/activate/#{user.id}?key=#{user.activ_key}"
    content_type  "text/html"
    sent_on       Time.now
  end

  def recovery_notification(user, passwd)
    recipients    user.email
    from          "no-reply@wikres.net"
    subject       "Recupération de votre mot de passe"
    body          :user => user, :passwd => passwd
    content_type  "text/html"
    sent_on       Time.now
  end

  def contact_notification(contact)
    recipients    [contact.email, "wikres@gmail.net"]
    from          "no-reply@wikres.net"
    subject       "Contact from " + contact.name
    body          :contact => contact
    content_type  "text/html"
    headers       "Reply-to" => "no-reply@wikres.net"
    sent_on       Time.now
  end

  def friend_request_notification(mail)
    recipients    mail[:friend].email
    from          'Wikres <no-reply@wikres.net>'
    subject       "New friend request at Wikres"
    body          mail
    content_type  "text/html"
    headers       "Reply-to" => "no-reply@wikres.net"
    sent_on       Time.now
  end
  
end
