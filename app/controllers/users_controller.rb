class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  
  def index
    @users = User.paginate( :page => params[:page] )
    @title = "All users"
  end
  def new
    @title = "Sign up"
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "welcome to the sample app" }
    else
      @title = "Sign up"
      render 'new'
    end
  end
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Your user profile has been updated" }
    else
      @title = "Edit user"
      render 'edit'      
    end
  end
  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, :flash => { :success => 'User destroyed.' }
  end
  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path, :notice => 'Unable to edit that profile!') unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_path) if (!current_user.admin? || current_user?( User.find(params[:id]) ))
    end
end