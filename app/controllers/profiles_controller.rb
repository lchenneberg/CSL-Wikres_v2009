class ProfilesController < ApplicationController
  before_filter :load_vars

  def index
    @latest_members = User.latest_members(10)

    #Search
    per_page = 15
    query = params[:query]
    conditions = ["username LIKE ? OR lastname LIKE ? OR firstname LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%"] unless params[:query].nil?
    @total = User.count(:conditions => conditions )
    @users = User.paginate :order => "lastname DESC", :page => params[:page],
      :conditions => conditions, :per_page => per_page

    if request.xml_http_request?
      render :partial => "profiles/search/users_list", :layout => false
    end
  end

  def show
    if @user
      @onSection = "#{@user.firstname} #{@user.lastname} profile"
      @weblogs = @user.weblogs.public_weblogs
      @friends = @user.friends.latest_friends(10)
      @latest_posts = @user.posts.latest_posts(10)
      @related_friends = logged_in_user.related_friends(@user) if logged_in_user
      
    else
      flash[:error] = "No account associated with #{@username}..."
      redirect_to :action => :index
    end
  end

  private

    def load_vars
      id = params[:id]
      unless id.nil?
        if id.to_i != 0
          @user = User.find_by_id(id)
        else
          @user = User.find_by_username(id)
        end
        if @user.nil?
          flash[:error] = "No account associated with #{id}..."
          redirect_to :action => :index
        else
          @username = @user.username
        end
      end
      
      
    end

end
