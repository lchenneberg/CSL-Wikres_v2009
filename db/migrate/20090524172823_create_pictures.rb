class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.text :description
      t.integer :parent_id, :size, :width, :height
      t.string :title, :content_type, :filename, :thumbnail

      t.references :user
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
