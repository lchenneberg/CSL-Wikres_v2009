module WsAuthentication

  public
  def self.get_current_user
    User.find_by_id(session[:user])
  end
  def self.is_admin?
    self.roles.find_by_name("Administrator") ? true : false
  end

  protected

  def self.included(base)
    base.send :helper_method, :is_logged_in?, :logged_in_user, :is_admin?
    
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def authorized?(user_id)
    is_logged_in?
    if user_id != logged_in_user.id || is_logged_in_admin? == false
      flash[:error] = t('auth.flash.deny_access')
    end
  end

  def login_required
    unless is_logged_in?
      respond_to do |wants|
        wants.html {
          self.store_location
          flash[:error] = t('auth.flash.login_required')
          redirect_to :controller => 'account', :action => 'login'
        }
        wants.xml {
          headers["Status"] = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Could not authenticate you", :status => '401 Unauthorized', :layout => false
        }
      end
    end
  end

  def is_logged_in?
    username, password = get_http_auth_data
    @logged_in_user = User.find(session[:user]) if session[:user]
    @logged_in_user = User.authenticate(username, password) if username && password
    @logged_in_user ? @logged_in_user : false
  end

  def is_logged_in_user_has_role?(rolename)
    unless logged_in_user
      false
    else
      logged_in_user.roles.find_by_name(rolename) ? true : false
    end
  end

  def logged_in_user
    return @logged_in_user if is_logged_in?
  end
  alias_method :current_user, :logged_in_user

  def logged_in_user=(user)
    if !user.nil?
      session[:user] = user.id
      @logged_in_user = user
      user.update_attribute(:last_login, Time.now)
    end
  end

  def check_role(role)
    respond_to do |wants|
        wants.html do
          self.store_location
          flash[:error] = t('auth.flash.deny_access')
          redirect_to :controller => 'account', :action => 'login'
        end
        wants.xml do
          headers['Status'] = 'Unauthorized'
          headers['WWW-Authenticate'] = %(Basic realm="Password")
          render :text => "Insuffient permission", :status => '401 Unauthorized', :layout => false
        end
      end unless is_logged_in? && @logged_in_user.has_role?(role)
  end

  def check_administrator_role
    check_role('Administrator')
  end
  def check_member_role
    check_role('Member')
  end
  def check_editor_role
    check_role('Editor')
  end

  private
    def get_http_auth_data
      username, password = nil, nil
      auth_headers = ['X-HTTP_AUTHORIZATION', 'Authorization', 'HTTP_AUTHORIZATION',
        'REDIRECT_REDIRECT_X_http_AUTHORIZATION']
      auth_header = auth_headers.detect{ |key| request.env[key] }
      auth_data = request.env[auth_header].to_s.split

      if auth_data && auth_data[0] == 'Basic'
        username, password = Base64.decode64(auth_data[1]).split(':')[0..1]
      end
      return [username, password]
    end

end
