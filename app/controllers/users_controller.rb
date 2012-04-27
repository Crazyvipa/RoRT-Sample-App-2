class UsersController < ApplicationController
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
end