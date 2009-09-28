class Collection < ActiveRecord::Base

  has_many :users
  has_many :weblogs
  has_many :posts

  belongs_to :user
  belongs_to :collectionable, :polymorphic => true
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..20

  def self.sgltypes
    [:user,:weblog,:post]
  end

end
