class CreateWeblogs < ActiveRecord::Migration
  def self.up
    create_table :weblogs do |t|
      t.string :name
      t.text :description
      t.boolean :public, :default => true
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :weblogs
  end
end
