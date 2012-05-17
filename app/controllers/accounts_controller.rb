class AccountsController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :login, :authenticate, :retrieve, :retrieve_action]

  def login
    redirect_back_or_default(account_url) if is_logged_in?
  end

  def show
    @user = current_user
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @passwd = params[:user][:password]
    #@user.activ_key = @user.keygen(@user.username)

    respond_to do |format|
      if @user.save
        flash[:notice] = t('account.flash.create_success')
        format.html { redirect_to :controller => "account", :action => "login" }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def authenticate
    self.current_user = User.authenticate(params[:user][:username], params[:user][:password])
    if is_logged_in?
      redirect_back_or_default(account_url)
    else
      flash[:error] = t('auth.flash.login_failed')
      redirect_to :action => 'login'
    end
  end

  def logout
    if request.post?
      reset_session
      flash[:notice] = t('auth.flash.logout_success')
    end
    redirect_to index_url
  end

  def retrieve
  end

  def retrieve_action
    #flash[:error] = "Veuillez saisir une adresse email valide."
    reg = /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
    email = params[:email]
    login = params[:login]

    if (reg.match(email))? true : false
      if @user = User.find_by_email_and_username_and_enabled(email,login,true)
        if @user.retrieve_password(@user)
          flash[:notice] = t('auth.flash.retrieve_success')
        else
          flash[:error] = t('auth.flash.retrieve_mail_failed')
        end
        redirect_to :action => 'login'
      else
        flash[:error] = t('auth.flash.bad_association')
        render :action => 'retrieve'
      end
    else
      flash[:error] = t('auth.flash.bad_email')
      render :action => 'retrieve'
    end
  end

  def profile
    @user = current_user
    @skills = Skill.find(:all)
  end

  def profile_update
    @user = current_user
    @skills = Skill.find(:all)
    @user.skills = Skill.find(params[:skill_ids]) if params[:skill_ids]
    respond_to do |format|
      if(@user.update_attributes(params[:user]))
        flash[:notice] = "Successfully updated..."
        format.html { redirect_to :action => :profile}
        format.xml  { render :xml => @user }
      else
        flash[:error] = "An error has raised..."
        format.html { render :action => :profile }
      end
    end
  end

  def set_avatar
    pict = Picture.find(params[:pict])
    current_user.set_avatar(pict)
    flash[:notice] = "Avatar successfully updated..."
    redirect_to :back
  end

  def unset_avatar
    current_user.lease
    redirect_to :back
  end

end
