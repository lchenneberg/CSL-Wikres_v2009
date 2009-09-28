class CreateRolesUsersJoin < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :null => false
      t.references :user, :null => false
    end
  end

  def self.down
    drop_table :roles_users
  end
end
