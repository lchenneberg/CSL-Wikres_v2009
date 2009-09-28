require 'digest/sha2'
class User < ActiveRecord::Base
  self.ws_admin :list_add_cols => [:username, :enabled, :email, :last_login]

  attr_protected :hashed_password, :enabled
  attr_accessor :password
  
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :skills

  has_one :avatar

  has_many :weblogs
  has_many :posts
  has_many :comments
  has_many :favorites
  has_many :collections
  has_many :pictures
  has_many :messages
  has_many :message_recipients
  has_many :received_messages, :through => :message_recipients, :order => "sent_at DESC",
           :source => :message, :conditions => {:status => "sent"}
  #has_many :unread_messages, :through => :message_recipients, :source => :message,
  #  :conditions => "message_recipients.read = 0"

  
  has_many :friends, :through => :friendships,
           :conditions => "status = 'accepted'", :order => :lastname
  has_many :requested_friends, :through => :friendships, :source => :friend,
           :conditions => "status = 'requested'", :order => :lastname
  has_many :pending_friends, :through => :friendships, :source => :friend,
           :conditions => "status = 'pending'", :order => :lastname
  has_many :friendships, :dependent => :destroy

  named_scope :latest_friends, lambda { |nb| { :limit => nb, :order => "accepted_at DESC" } }
  named_scope :latest_members, lambda { |nb| { :limit => nb, :order => "created_at DESC"} }

  #has_many :skills
  #has_many :projects
  #has_many :project_bids

  validates_presence_of :username
  validates_presence_of :email
  
  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :create
  validates_presence_of :password, :if => :password_required?, :on => :update
  validates_presence_of :password_confirmation, :if => :password_required?, :on => :update

  validates_presence_of :firstname
  validates_presence_of :lastname
  validates_presence_of :birthdate

  validates_confirmation_of :password, :if => :password_required?

  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false

  validates_length_of :username, :within => 3..64
  validates_length_of :email, :within => 5..128
  validates_length_of :password, :within => 4..20, :if => :password_required?
  validates_length_of :profile, :maximum => 1000
  validates_length_of :firstname, :within => 2..64
  validates_length_of :lastname, :within => 2..64
  validates_length_of :mobile, :is => 10,
                      :message => "Veuillez entrer les 10 chiffres de votre numero de téléphone"

  validates_format_of :email, :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                      :message => "Votre addresse email n'est pas valide"
  validates_format_of :username, :with => /^[A-Z0-9_]*$/i,
                      :message => "Le nom d'utilisateur ne peut contenir que des lettres ou '_'."

  validates_numericality_of :mobile, :message => "Veuillez saisir un numero de téléphone valide."


  def before_save
    self.hashed_password = User.encrypt(password) if !self.password.blank?
  end
  def before_create
    self.activ_key = keygen(self.username)
  end
  def after_create
    Notifier.deliver_signup_notification(self)
  end

  def password_required?
    self.hashed_password.blank? || !self.password.blank?
  end
  def password_confirm_required?
    if self.password_confirmation.nil?
      return false
    else
      self.hashed_password.blank? || !self.password.blank?
    end
  end

  def self.encrypt(string)
    return Digest::SHA256.hexdigest(string)
  end

  def self.authenticate(login, password)
    reg = /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
    if (reg.match(login))? true : false
      find_by_email_and_hashed_password_and_enabled(login, User.encrypt(password), true)
    else
      find_by_username_and_hashed_password_and_enabled(login, User.encrypt(password), true)
    end
  end

  def fullname
    "#{lastname.capitalize} #{firstname.capitalize}"
  end

  def has_role?(rolename)
    self.roles.find_by_name(rolename) ? true : false
  end

  def keygen(key)
    return Digest::SHA256.hexdigest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}/#{key}")[0,6]
  end

  def retrieve_password(user)
    passwd = keygen(user.username)
    user.hashed_password = User::encrypt(passwd)
    user.save
    Notifier::deliver_recovery_notification(user, passwd) ? true : false
  end

  def related_friends(user)
    User.find_by_sql ["SELECT * FROM users u, friendships f
                  WHERE u.id = f.friend_id AND f.user_id = ? AND f.friend_id IN
                  (SELECT friend_id FROM friendships WHERE user_id = ? AND status = 'accepted' AND friend_id != ?)", self.id, user.id, self.id]

  end
  def related_friends_count(user)
    x = User.find_by_sql ["SELECT u.id FROM users u, friendships f
                  WHERE u.id = f.friend_id AND f.user_id = ? AND f.friend_id IN
                  (SELECT friend_id FROM friendships WHERE user_id = ? AND status = 'accepted' AND friend_id != ?)", self.id, user.id, self.id]
    x.count
  end

  def set_avatar(pic)
    unless self.avatar.nil?
      self.unset_avatar
    end
    avt = Avatar.new
    avt.picture_id = pic.id
    avt.user_id = self.id
    User.find(self.id).avatar = avt
    return true
  end
  def unset_avatar
    avt = Avatar.find_by_user_id(self.id)
    avt.destroy if avt
  end


end