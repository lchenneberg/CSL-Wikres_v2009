class Wsapi::UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
    render :xml => @users.to_xml(:only => [:username, :firstname, :lastname, :email])
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    render :xml => @user.to_xml(:except => [:hashed_password, :activ_key], :include => [:friends, :pictures, :messages])
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
        format.html { redirect_to :action => 'show', :id => logged_in_user }
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
end
