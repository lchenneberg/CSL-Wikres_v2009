class RolesController < ApplicationController
  before_filter :check_administrator_role

  # GET /roles
  # GET /roles.xml
  def index
    @all_roles = Role.all
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    unless @user.has_role?(@role.name)
      @user.roles << @role
    end
    redirect_to :action => 'index'
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    if @user.has_role?(@role.name)
      @user.roles.delete(@role)
    end
    respond_to do |format|
      format.html {redirect_to :action => 'index' }
      format.xml  { head :ok }
    end
    
  end
end
