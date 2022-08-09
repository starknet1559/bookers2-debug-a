class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today = @books.where(created_at: Time.zone.now.all_day).count
    @yesterday = @books.where(created_at: 1.day.ago.all_day).count
    @comp_preday = @today / @yesterday rescue 0
    @this_week = @books.where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day ).count
    @last_week = @books.where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day).count
    @week = @this_week / @last_week rescue 0
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
