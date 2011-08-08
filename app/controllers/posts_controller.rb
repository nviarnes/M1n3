class PostsController < ApplicationController
  include SessionsHelper
  before_filter :authenticate
  before_filter :authorized_user, :only => [:edit, :destroy]
  
  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 3 )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  
  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      redirect_to root_path, :flash => { :success => "Post created!" }
    else
     render 'posts/new'
    end
  end


  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
     @post.destroy
      redirect_to root_path, :flash => { :success => "Post deleted!" }
  end
  
  private

     def authorized_user
       @post = current_user.posts.find_by_id(params[:id])
       redirect_to root_path if @post.nil?
     end
     
     def admin_user
       @user = User.find(params[:id])
       redirect_to(root_path) if !current_user.admin? || current_user?(@user)
     end
  
end
