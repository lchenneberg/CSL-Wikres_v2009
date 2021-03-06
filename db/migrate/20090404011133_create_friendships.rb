class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.references :user
      t.references :friend
      t.string :status
      t.datetime :accepted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
