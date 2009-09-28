class CommentsController < ApplicationController
  before_filter :check_administrator_role, :except => [:index, :new, :create]
  before_filter :login_required, :only => [:new, :create]
  before_filter :load_parent
  before_filter :load_comment


  # GET /comments
  # GET /comments.xml
  def index
    #@commentable = find_commentable
    #@comments = @commentable.comments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])

    respond_to do |format|
      if @comment.save
        logged_in_user.comments << @comment
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to :id => nil }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to :action => :index }
      format.xml  { head :ok }
    end
  end

  private
    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)able_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

  protected
    def load_parent
    end
    def load_comment
      @comments = @parent.comments
    end

end
