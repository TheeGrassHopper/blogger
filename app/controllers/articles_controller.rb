class ArticlesController < ApplicationController

    before_action :get_article, only: %i[show update destroy]

    def index
        articles = Article.paginate(page: params[:page], per_page: 10).order('id DESC')
        if params[:search]
            articles = articles.select{ |article| article.search(params[:search]) }
        end
        render json: articles.to_json, status: :ok    
    end


    def show
        if @article
            render json: @article.to_json, status: :ok    
        else
            render json: { status: "Error", message: "ActiveRecord::RecordNotFound"}, status: :not_found
        end
    end

    def create 
        if new_article = Article.create!(article_params)
            render json: { status: "Success", message: "Created", data: new_article }, status: :created
        else
            render json: { status: "Error", message: "ActiveRecord::RecordInvalid", data: new_article.errors.full_message }, status: :unprocessable_entity
        end
    end
    
    def update
        if @article && @article.update(article_params)
            render json: { status: "Success", message: "updated", data: @article }, status: :no_content
        else
            render json: { status: "Error", message: "ActiveRecord::RecordNotFound", data: @article.errors.full_message }, status: :not_found
        end
    end

    
    def destroy
        if @article && @article.destroy
            render json: { status: "Success", message: "Deleted", data: @article }, status: :no_content
        else
            render json: { status: "Error", message: "ActiveRecord::RecordNotFound", data: @article.errors.full_message}, status: :not_found
        end
    end

    private

    def get_article
        @article ||= Article.find_by(id: params[:id])    
    end

    def article_params
        params.require(:article).permit(:title, :body)
    end
end
