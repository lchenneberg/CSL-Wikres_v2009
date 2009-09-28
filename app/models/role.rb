class Role < ActiveRecord::Base
  self.ws_admin :list_add_cols => [:name, :updated_at]
  
  has_and_belongs_to_many :users

  validates_presence_of :name
end
