class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy]
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    @feed_items = []
    if @micropost.save
      redirect_to root_path, :flash => { :success => "Micropost created!" }
    else
      render 'pages/home'
    end
  end
  def destroy
    @micropost.destroy
    redirect_to root_path, :flash => { :success => "Removed micropost!" }
  end
  private
    def authorized_user
      @micropost = Micropost.find(params[:id])
      redirect_to root_path unless current_user?(@micropost.user)
    end
end