class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name, :null => false
      t.text :description, :limit => 128

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
