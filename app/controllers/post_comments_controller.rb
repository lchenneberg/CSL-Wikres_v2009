class PostCommentsController < CommentsController

  def index

  end

  def create
    #@commentable = find_commentable
    @comment = @post.comments.build(params[:comment])

    respond_to do |format|
      if current_user.comments << @comment
        flash[:notice] = 'Comment was successfully created.'
        #format.html { redirect_to :action => :show, :id => @comment.id }
        format.html { redirect_to :action => :index }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def load_parent
    @parent = @post = Post.find(params[:post_id])
  end
end
