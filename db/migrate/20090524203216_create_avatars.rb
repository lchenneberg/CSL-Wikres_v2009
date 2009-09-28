class CreateAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars do |t|
      t.references :user
      t.references :picture
      t.timestamps
    end
  end

  def self.down
    drop_table :avatars
  end
end
