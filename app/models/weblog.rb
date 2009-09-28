class Weblog < ActiveRecord::Base
  belongs_to :user
  has_many :posts, :as => :postable

  named_scope :public_weblogs, :conditions => {:public => true}

  validates_presence_of :name
end
