class Privacy
  attr_reader :user, :blacklist, :acls, :public

  def initialize(user)
    @user = user
    @blacklist = user.blacklist
    @acls = user.acls
  end

  def check_access
    
  end

  def self.friendship(usr2,usr1=@user)

  end

end