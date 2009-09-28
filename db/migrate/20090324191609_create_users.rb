class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :username, :limit => 64, :null => false
      t.string    :email, :limit => 128, :null => false
      t.string    :hashed_password, :limit => 64, :null => false
      t.boolean   :enabled, :default => false, :null => false
      t.text      :profile
      t.string    :firstname
      t.string    :lastname
      t.integer   :gender, :limit => 1
      t.date      :birthdate
      t.string    :mobile, :limit => 10
      t.datetime  :last_login
      t.string    :activ_key, :limit => 6, :null => false

      t.timestamps
    end
    add_index :users, :username
  end

  def self.down
    drop_table :users
  end
end
