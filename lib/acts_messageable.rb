module Wikres
  module Acts
    module Messageable
      def self.included base
        base.extends ClassMethods
      end

      module ClassMethods
        include Wikres::Acts::Messageable::InstanceMethods
        extends Wikres::Acts::Messageable::SingletonMethods
      end

      module SingletonMethods
        
      end

      module InstanceMethods

        def inbox(options = {})
          Message.received_messages self, options
        end
        def new_messages(options = {})
          Message.unread_received_messages self, options
        end
        def new_messages?
          self.new_messages.count > 0
        end
        def outbox(options = {})
          self.sent_messages self, options
        end
        def read_message(message_id)
          self.sent_messages self, message_id
        end
        def send_message(receiver, subject, body)
          Message.new(:receiver => receiver, :sender => self,
            :subject => subject,:body => body).save
        end
        def delete_message(message_id)
          Message.trash_message self, message_id
        end


      end

    end
  end
end