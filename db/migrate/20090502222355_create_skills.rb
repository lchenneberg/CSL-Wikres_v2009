class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.string :name
      t.string :description
      t.integer :parent_id

      t.references :user

      t.timestamps
    end

    #Initialize
    Skill.create(:user_id => 1, :name => "AJAX")
    Skill.create(:user_id => 1, :name => "ASP")
    Skill.create(:user_id => 1, :name => "J2EE")
    Skill.create(:user_id => 1, :name => "JME")
    Skill.create(:user_id => 1, :name => "Java")
    Skill.create(:user_id => 1, :name => "JavaFX")
    Skill.create(:user_id => 1, :name => "Html / xHtml")
    Skill.create(:user_id => 1, :name => "XML / XSS")
    Skill.create(:user_id => 1, :name => "Javascript")
    Skill.create(:user_id => 1, :name => "Ruby")
    Skill.create(:user_id => 1, :name => "Python")
    Skill.create(:user_id => 1, :name => "C / C++")
    Skill.create(:user_id => 1, :name => "C#")
    Skill.create(:user_id => 1, :name => "Flash")
    Skill.create(:user_id => 1, :name => "Perl")
    Skill.create(:user_id => 1, :name => "MySQL")
    Skill.create(:user_id => 1, :name => "Oracle")
    Skill.create(:user_id => 1, :name => ".NET")
    Skill.create(:user_id => 1, :name => "Rails")
    Skill.create(:user_id => 1, :name => "Django")
    
  end

  def self.down
    drop_table :skills
  end
end
