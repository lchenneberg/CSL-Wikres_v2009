class Message < ActiveRecord::Base
  belongs_to :user
  has_many :recipients, :class_name => 'MessageRecipient',
    :order => 'position ASC', :dependent => :destroy

  named_scope :visible, :conditions => {:hidden_at => nil}
  named_scope :unsent, :conditions => {:status => "unsent", :hidden_at => nil}, :order => "created_at DESC"
  named_scope :sent, :conditions => {:status => "sent", :hidden_at => nil}, :order => "created_at DESC"

  #validates_presence_of :user_id
  #after_save :update_recipients

  def self.received(user)
    received = []
    recipients = MessageRecipient.find_all_by_user_id_and_hidden_at(user,nil)
    for recipient in recipients
      received << recipient.message
    end
    received
  end
  def self.received?(user)
    self.received(user) > 0
  end

  def send_message!
    @message = self
    self.status = "sent"
    self.sent_at = DateTime.now
    if self.save
      true
    else
      false
    end
  end

  def read!(user)
    rec = self.recipients.find_by_user_id(user.id)
    rec.read = true
    rec.save
  end
  def read?(user)
    rec = self.recipients.find_by_user_id(user.id)
    rec.read == true
  end


end
