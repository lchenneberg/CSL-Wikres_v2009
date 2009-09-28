class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates_presence_of :content

  def self.find_comments_by_user(user)
    find( :all, :conditions => ["user_id = ?", user.id],
          :order => "created_at DESC")
  end

  def self.find_comments_for_commentable(commentable_str, commentable_id)
    find( :all,
      :conditions => ["commentable_type = ? and commentable_id = ?", commentable_str, commentable_id],
      :order => "created_at DESC")
  end

  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

end
