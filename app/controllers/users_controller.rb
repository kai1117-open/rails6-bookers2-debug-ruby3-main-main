class UsersController < ApplicationController
before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @total_views = @user.books.sum(&:impressionist_count)
    @book = Book.new
    
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    
      @daily_books = (0..6).map do |i|
        day = i.days.ago.to_date
        { date: day.strftime("%Y-%m-%d"), count: @user.books.created_on(day).count }
      end
  end
  
    def check_daily_books
      @user = User.includes(:books).find(params[:id])
      date = params[:date].to_date
      @book_count = @user.books.created_on(date).count
    
      respond_to do |format|
        format.js
      end
    end  
  
  
  

  def index
    @users = User.all
    @book = Book.new
  end
  
  def edit
    
    @user = User.find(params[:id])

  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
       render :edit
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
