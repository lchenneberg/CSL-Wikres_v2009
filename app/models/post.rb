class Post < ActiveRecord::Base
  
  self.ws_admin :list_add_cols => [:title, :published, :published_at]

  has_many :comments, :as => :commentable

  belongs_to :user
  belongs_to :postable, :polymorphic => true

  named_scope :latest_posts, lambda { |nb| { :limit => nb, :order => "created_at DESC" } }

  validates_presence_of :title
  validates_presence_of :summary
  validates_presence_of :content

  validates_length_of :title, :within => 4..128
  validates_length_of :summary, :within => 4..255
  validates_length_of :keywords, :maximum => 128
  validates_length_of :content, :minimum => 16

  def before_save
    if self.published && self.published_at.nil?
      self.published_at = Time.now
    end
  end

end
