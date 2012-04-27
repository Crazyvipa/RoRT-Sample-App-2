class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  
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
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Your user profile has been updated" }
    else
      @title = "Edit user"
      render 'edit'      
    end
  end
  
  private
    def authenticate
      deny_access unless signed_in?
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path, :notice => 'Unable to edit that profile!') unless current_user?(@user)
    end
end