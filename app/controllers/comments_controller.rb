class CommentsController < ApplicationController


  before_filter :require_context
  add_crumb(proc { t '#crumbs.comments', "Comments" }, :except => [:new,:destroy]) { |c| c.send :course_comments_path, c.instance_variable_get("@context") }
  before_filter { |c| c.active_tab = "Comments" }
  before_filter :load_commentable

  def new
    @comment = Comment.new
    #@course = Course.find(params[:commentable])
    #@commentable_type = params[:commentable_type]
    #@commentable_id = params[:commentable]

  end

  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.user_id = @current_user.id
    @comment.title =  params[:comments][:title]
    @comment.comment = params[:comments][:comment]
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable }
        flash[:info] = "Your review is added "
      else
        format.html { render :action => 'new' }
      end
    end
  end

  def destroy
     @comments = Comment.find(params[:id])
     @comments.destroy
     #flash[:success] = "Successfully Destroyed Category."
     flash[:notice] = t(:deleted_comments, "Successfully deleted")
    redirect_to :back
  end

  def review
    #@course =@commentable
    #@comment=Comment.new
    #if user_can_do?(@course)
    #  @comments= @course.comments
    #else
    #  @comments=[]
    #  #@comment_list= @course.comments.active
    #  @comment_list.each do |comment|
    #    @comments << comment
    #  end
    #end

  end

  def show
  end

  def edit
    @comments = Comment.find(params[:id])


  end


  def update
    @comments = Comment.find(params[:id])
    @comment.title =  @comments.title
    @comment.comment = @commemnts.comment
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable }
      end
    end
  end


  def index
    #add_crumb("Comments", named_context_url(@context, :context_comments_url))
    #@active_tab = "Comments"
    @comments = @commentable.comments.recent.limit(100).all
  end

  def load_commentable
      @commentable = Course.find(params[:course_id])
      #@comments = @commentable.comment.recent.limit(10).all
      #@commentable = Course.find(params[:commentable_id])
      #@comments = @commentable.comments.recent.limit(10).all

  end

end
