class ArticlesController < ApplicationController

    before_action :get_article, only: %i[show update destroy]

    def index
        articles = Article.paginate(page: params[:page], per_page: 10).order('id DESC')
        if params[:search]
            articles = articles.select{ |article| article.search(params[:search]) }
        end
        render json: { status: "Success", data: articles }, status: :ok    
    end


    def show
        if @article
            render json: { status: "Success", data: @article }, status: :ok    
        else
            render json: { status: "Error", data: nil}, status: :not_found
        end
    end

    def create
        new_article = Article.new(article_params)
        if new_article.save
            render json: { status: "Success", data: new_article }, status: :created
        else
            render json: { status: "Error", data: new_article.errors }, status: :unprocessable_entity
        end
    end
    
    def update
        if @article && @article.update(article_params)
            render json: { status: "Success", data: @article }, status: :no_content
        else
            render json: { status: "Error", data: @article.errors }, status: :not_found
        end
    end

    
    def destroy
        if @article && @article.destroy
            render json: { status: "Success", data: @article }, status: :no_content
        else
            render json: { status: "Error", data: nil }, status: :not_found
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
