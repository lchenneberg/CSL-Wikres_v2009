class FillTables < ActiveRecord::Migration
  def self.up

    #Create Roles
    Role.create(:name => 'Root', :description => 'Super users, all rights')
    Role.create(:name => 'Administrator', :description => 'Administrators, can\'t delete others administrators')
    Role.create(:name => 'Editor', :description => 'Editors')
    Role.create(:name => 'Member', :description => 'Simple users')
    Role.create(:name => 'Visitor', :description => 'Users without accounts')

    #Create UserAdmin
    root_user = User.create(:username => 'Root', :email => 'Root@Wikres.com',
      :profile => 'Administrator user', :password => 'Password0', :password_confirmation => 'Password0',
      :activ_key => '000000', :profile => 'Administrator', :firstname => 'Admin',
      :lastname => 'Admin', :birthdate => Time.now.localtime.strftime("%Y-%m-%d"), :mobile => '0000000000')
    admin_user = User.create(:username => 'Admin', :email => 'Admin@Wikres.com',
      :password => 'Password', :password_confirmation => 'Password',
      :activ_key => '000000', :profile => 'Administrator', :firstname => 'Admin',
      :lastname => 'Admin', :birthdate => Time.now.localtime.strftime("%Y-%m-%d"), :mobile => '0000000000')

    test_user = User.create(:username => 'Test', :email => 'Test@Wikres.com',
      :password => 'Password', :password_confirmation => 'Password',
      :activ_key => '000000', :profile => 'Test Account', :firstname => 'Test',
      :lastname => 'Account', :birthdate => Time.now.localtime.strftime("%Y-%m-%d"), :mobile => '0000000000')

    admin_user.enabled = true;
    test_user.enabled = true;
    #Set Admin Roles
    root_role = Role.find_by_name('Root')
    admin_role = Role.find_by_name('Administrator')
    editor_role = Role.find_by_name('Editor')
    member_role = Role.find_by_name('Member')


    root_user.roles << root_role
    admin_user.roles << admin_role
    admin_user.roles << editor_role
    admin_user.roles << member_role
    test_user.roles << member_role
    
    root_user.save
    admin_user.save
    test_user.save


  end

  def self.down
    #Delete UserAdmin
    #admin_user = User.find_by_username('Admin')
    #admin_user.destroy
  end
end
