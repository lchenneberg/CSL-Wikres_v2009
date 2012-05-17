class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :load_parent
  before_filter :load_post

  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.all
    @test = params[:weblog_id]
    puts @test
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        current_user.posts << @post
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
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
        format.html { redirect_to(@post) }
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
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end

  def create_comment
    #@commentable = find_commentable
    @post = Post.find(params[:id])
    @comment = @post.comments.build(params[:comment])

    respond_to do |format|
      if current_user.comments << @comment
        flash[:notice] = 'Comment was successfully created.'
        #format.html { redirect_to :action => :show, :id => @comment.id }
        format.html { redirect_to profile_post_path(params[:user_id], @post) }
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
    if current_user.id == @post.user_id || current_user.id == @comment.user_id
      @comment.destroy
      flash[:notice] = "Successfully destroyed..."
    else
      flash[:error] = "You've got right to delete this post..."
    end

    respond_to do |format|
      format.html { redirect_to profile_post_path(params[:user_id], @post) }
      format.xml  { head :ok }
    end
  end


  protected
  #PolymorphicSolution
  def load_parent #Overriden function
    #@parent = params[:user_id]
  end
  def load_post
    @posts = @parent.posts unless @parent.nil? 
  end

end

