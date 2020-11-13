class CommentsController < ApplicationController
    before_action :article, only: %i[create destory]
    before_action :comment, only: %i[update show destroy]

    def index
        comments = Comment.paginate(page: params[:page], per_page: 10).order(id: :desc)
        if params[:article_id]
            comments = article.comments
        end
        render json: { status: "Success", data: comments }, status: :ok
    end

    def show
        render json: { status: "Success", data: @comment }, status: :ok
    end
    
    def create
        comment = Comment.new(comment_params)
        if @article && comment.save
            render json: { status: "Success", data: comment }, status: :created
        else
            render json: { status: "Error", data: comment.errors }, status: :unprocessable_entity
        end
    end

    def update
        if @comment && @comment.update(comment_params)
            render json: { status: "Success", data: @comment }, status: :no_content
        else
            render json: { status: "Error", data: @comment.errors }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordNotFound
        render json: { error: error.message }, status: :not_found
    end
    
    def destroy
        if @comment && @comment.destroy
            render json: { status: "Success", data: @comment }, status: :no_content
        else
            render json: { status: "Error", data: @comment.errors }, status: :unprocessable_entity
        end
    end
    
    private 

    def article
        @article = Article.find(params[:article_id])
    end

    def comment
        @comment = Comment.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:commenter, :body, :article_id)
    end
end
