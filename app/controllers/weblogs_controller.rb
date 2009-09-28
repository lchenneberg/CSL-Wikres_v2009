class WeblogsController < ApplicationController
  before_filter :login_required
  # GET /weblogs
  # GET /weblogs.xml
  def index
      @current_user = logged_in_user;
      @weblogs = @current_user.weblogs
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weblog }
    end
  end

  # GET /weblogs/1
  # GET /weblogs/1.xml
  def show
    @weblog = Weblog.find(params[:id])
    @posts = @weblog.posts.find(:all,:conditions => ["published = ?", true])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @weblog }
    end
  end

  # GET /weblogs/new
  # GET /weblogs/new.xml
  def new
    @weblog = Weblog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weblog }
    end
  end

  # GET /weblogs/1/edit
  def edit
    @weblog = Weblog.find(params[:id])
  end

  # POST /weblogs
  # POST /weblogs.xml
  def create
    @weblog = Weblog.new(params[:weblog])

    respond_to do |format|
      if logged_in_user.weblogs << @weblog
        flash[:notice] = 'Weblog was successfully created.'
        format.html { redirect_to account_weblog_url(@weblog) }
        format.xml  { render :xml => @weblog, :status => :created, :location => @weblog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @weblog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weblogs/1
  # PUT /weblogs/1.xml
  def update
    @weblog = Weblog.find(params[:id])

    respond_to do |format|
      if @weblog.update_attributes(params[:weblog])
        flash[:notice] = 'Weblog was successfully updated.'
        format.html { redirect_to account_weblog_url(@weblog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weblog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /weblogs/1
  # DELETE /weblogs/1.xml
  def destroy
    @weblog = Weblog.find(params[:id])
    @weblog.destroy

    respond_to do |format|
      format.html { redirect_to account_weblogs_path }
      format.xml  { head :ok }
    end
  end

  def enable
    if !logged_in_user.weblog.nil?
      flash[:notice] = "Weblog is already enabled."
    else
      logged_in_user.weblog = Weblog.new
      flash[:notice] = "Weblog was successfully created."
    end
    redirect_to manage_user_url(logged_in_user.id)
  end
end
