class Weblogs::PostsController < PostsController

  # GET /posts
  # GET /posts.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # POST /posts
  # POST /posts.xml
  def create

    respond_to do |format|
      @post = @parent.posts.build(params[:post])
      @post.weblog_id = @parent.id
      if logged_in_user.posts << @post
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to :action => :show, :id => @post.id }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to account_weblog_post_path(@post.weblog_id ,@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(account_weblog_posts_url(params[:weblog_id])) }
      format.xml  { head :ok }
    end
  end

  def create_comment
    #@commentable = find_commentable
    @post = Post.find(params[:id])
    @comment = @post.comments.build(params[:comment])

    respond_to do |format|
      if logged_in_user.comments << @comment
        flash[:notice] = 'Comment was successfully created.'
        #format.html { redirect_to :action => :show, :id => @comment.id }
        format.html { redirect_to :action => :show, :id => @post.id }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        format.js
      else
        flash[:error] = "An error has raised..."
        format.html { render :action => :show, :id => @post.id }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy_comment
    @post = Post.find(params[:id])
    @comment = Comment.find(params[:com])
    if logged_in_user.id == @post.user_id || logged_in_user.id == @comment.user_id
      @comment.destroy
      flash[:notice] = "Successfully destroyed..."
    else
      flash[:error] = "You've got right to delete this post..."
    end

    respond_to do |format|
      format.html { redirect_to :action => :show, :id => params[:id] }
      format.xml  { head :ok }
    end
  end


  def load_parent
    @parent = @weblog = Weblog.find(params[:weblog_id])
  end
end
