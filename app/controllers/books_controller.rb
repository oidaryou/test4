class BooksController < ApplicationController
  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @books = @user.books.page(params[:page]).reverse_order
    @new_book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
    @user = @book.user
    if @user == current_user
     render "edit"
    else
     redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:success] = "You have updated book successfully."
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def create
     @book = Book.new(book_params)
     @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    if
      flash[:success] = "Book was successfully destroyed."
      redirect_to books_path
    end
  end


  private
  def book_params
    params.require(:book).permit(:title, :body)
  end
end
