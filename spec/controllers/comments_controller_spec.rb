require 'rails_helper'

describe CommentsController, type: :controller do
    let!(:articles) { FactoryBot.create_list(:article, 21) }
    let!(:comments) do
        articles.map { |article| [].push(FactoryBot.create_list(
            :comment,
            (1..10).to_a.sample,
            article: article))
        }.flatten
    end

    describe "GET #index" do
        before do
            get :index, params: { page: 1 }
        end
        context "return all comments" do

            it "returns all comments paginated limit 10" do
                expect(JSON.parse(response.body)["data"].count).to eq(10)
            end
        end

        context "passing article_id query param" do
            context "article exists" do
            let(:article_id) { articles.sample.id }
            let(:article) { Article.find(article_id) }
                it "comments for article" do
                    get :index, params: { article_id: article_id }
                
                    expect(JSON.parse(response.body)["data"].count).to eq(article.comments.count)
                end
            end

            context "article does not exist" do
                let(:article_id) { -1 }
                it "raise error" do 
                    expect {
                        get :index, params: { article_id: article_id }
                    }.to raise_error(ActiveRecord::RecordNotFound) 
                end
            end
        end
    end

    describe 'GET #show' do
        context "comment exist" do   
            let(:comment_id) { articles.first.comments.first.id }
            let(:comment) {  Comment.find(comment_id) }     
            
            it "returns a comment" do
              get :show, params: { id: comment_id }
              expect(response.status).to eq 200
              expect(JSON.parse(response.body)["data"].to_json).to eq(comment.to_json)
            end
          end
      
          context "comment does not exist" do
            let(:comment_id) { -1 }
            it "raise error" do 
                expect {
                    get :show, params: { id: comment_id }
                }.to raise_error(ActiveRecord::RecordNotFound) 
            end
          end
    end

    describe 'POST #create' do
        let(:commenter) { Faker::Name.name }
        let(:body) { Faker::Quote.famous_last_words }
        let(:article_id) { articles.first.id }
        
        let(:create_params) do
            {
                commenter: commenter,
                body: body,
                article_id: article_id 
            }
        end
        
        let(:params) { { comment: create_params } }

        before do
            allow(Article).to receive(:find).and_return(articles.first)
            post :create, params: params
        end

        context "with valid params" do
            it "succeeds" do
                expect(JSON.parse(response.body)["data"]["body"]).to eq(body)
                expect(JSON.parse(response.body)["data"]["commenter"]).to eq(commenter)
                expect(response.status).to eq(201)
            end
        end
    
        context 'missing parameters' do
            [:body, :commenter].each do |key|
                let(:params) { { comment: create_params.except(key) } }
                it 'returns an error' do
                    expect(response).to have_http_status(422)
                end
            end
        end
    end

    describe 'PUT #update' do
        let(:comment_id) { articles.first.comments.first.id }
        let(:body) { "Updated body" }
        before do 
            put :update, params: { id: comment_id, comment: { body: body } }
        end

        context "with valid params" do 
            it "Success" do
                expect(JSON.parse(response.body)["data"]["body"]).to eq(body)
            end
        end
        context "with invalid params" do
            let(:body) { nil }
            it "Erros" do
                expect(JSON.parse(response.body)["data"]["body"]).to eq(["can't be blank"])
            end
        end
    end

    describe 'DELETE #destroy' do
        let(:comment) { FactoryBot.build(:comment, id: 1) }

        context 'when user delete\'s comment' do
            before do 
                allow(Comment).to receive(:find).and_return(comment)
            end
           it "delete coment" do
                delete :destroy, params: { id: comment }
                expect(response).to have_http_status(204)
            end 
        end
    end
end
