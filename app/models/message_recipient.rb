class MessageRecipient < ActiveRecord::Base
  belongs_to :message
  belongs_to :user

  named_scope :unread, :conditions => {:status => "unread"}

end
