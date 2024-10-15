class BookCommentsController < ApplicationController
  
 def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    
    if comment.save
      redirect_to book_path(book)
    else
      render book_path(book)
    end
    
 end

def destroy
  book_comment = BookComment.find(params[:id])
  book = book_comment.book
  book_comment.destroy
  redirect_to book_path(book), notice: 'コメントが削除されました。'

end



  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

  
  
end
