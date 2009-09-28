class Collected < ActiveRecord::Base
  validates_presence_of :collectable_id, :collectable_type, :user_id
  validates_uniqueness_of :user_id, :scope => [:collectable_id, :collectable_type, :collection_id]
end
