class Favorite < ActiveRecord::Base
  belongs_to :faveable, :polymorphic => true
  belongs_to :user
end
