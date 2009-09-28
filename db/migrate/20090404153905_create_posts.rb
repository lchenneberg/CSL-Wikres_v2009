class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title, :null => false, :limit => 128
      t.text :summary, :limit => 255
      t.text :content, :null => false
      t.string :keywords, :limit => 128
      t.boolean :published, :default => false
      t.datetime :published_at

      t.references :weblog
      t.references :user
      t.references :postable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
