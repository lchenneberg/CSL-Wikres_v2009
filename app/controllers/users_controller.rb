class UsersController < ApplicationController
  #before_filter :check_administrator_role, :only => [:index, :destroy, :enable_toggle]
  #before_filter :login_required, :only => [:edit, :update]

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
      format.js
    end
  end

  def show_by_username
    @user = User.find_by_username(params[:username])
    render :action => 'show'
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
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

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = t('account.flash.update_success')
        format.html { redirect_to :action => 'show', :id => current_user }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
      flash[:notice] = "Account has been deleted successfully"

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "Account actived"
    else
      flash[:error] = "An error has raised"
    end
    redirect_to :action => 'index'
  end

  def disable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "Account has been disabled successfully."
    else
      flash[:error] = "An error has raised during process."
    end
    redirect_to :action => 'index'
  end


  def activate
    @user = User.find(params[:id])
    if @user.activ_key == params[:key]
      if @user.update_attribute(:enabled, true)
        flash[:notice] = t('account.flash.activ_success')
      else
        flash[:error] = t('account.flash.activ_failed')
      end
      redirect_to :action => 'login', :controller => "account"
    else
      flash[:error] = t('account.flash.bad_activ_key')
    end

  end

  def retrieve
    reg = /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
    identifier = params[:identifier]
    if (reg.match(identifier))? true : false
      @user = User.find_by_email_and_enabled(identifier, true)
      redirect_to :action => 'index'
    else
      flash[:error] = t('auth.flash.bad_email')
      render :action => 'retrieve'
    end
  end

  def manage
    @user = User.find(params[:id])
    @weblog_exists = !@user.weblog.nil?
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

end
