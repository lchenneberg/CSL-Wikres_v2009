class CreateSkillsUsersJoin < ActiveRecord::Migration
  def self.up
    create_table :skills_users, :id => false do |t|
      t.references :skill
      t.references :user
    end
  end

  def self.down
    drop_table :skills_users
  end
end
