require 'activerecord'

module Wikres
  module Acts
    module Commentable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_commentable
          has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
          include Wikres::Acts::Commentable::InstanceMethods
          extend Wikres::Acts::Commentable::SingletonMethods
        end
      end

      module SingletonMethods
        def find_comments_for(obj)
          commentable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          Comment.find(:all,
            :conditions => ["commentable_id = ? and commentable_type = ?", obj.id, commentable],
            :order => "created_at DESC")
        end

        def find_comment_by_user(user)
          commentable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          Comment.find(:all,
            :conditions => ["user_id = ? and commentable_type = ?", user.id, commentable],
            :order => "created_at DESC")
        end

      end

      module InstanceMethods
        def comments_ordered_by_submitted
          Comment.find(:all,
            :condition => ["commentable_id = ? and commentable_type = ?", id, self.type.name],
            :order => "created_at DESC")
        end
        def add_comment(comment)
          comments << comment
        end
      end

    end
  end
end

ActiveRecord::Base.send(:include, Wikres::Acts::Commentable)