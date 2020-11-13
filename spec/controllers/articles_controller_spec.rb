require 'rails_helper'


describe ArticlesController, type: :controller do
    let!(:articles) { FactoryBot.create_list(:article, 10) }

    describe "GET #index" do
      
      context "return all articles" do
        before do
            get :index, params: { page: 1 }
        end
  
        it "returns all articles paginated limit 10" do
          expect(JSON.parse(response.body)["data"].count).to eq(10)
        end
      end
      
      context "when search params is passed" do
        it "returns article article title" do
            get :index, params: { search: articles.first.title }
            expect(JSON.parse(response.body)["data"]).to_not be_empty
        end

        it "returns article article body" do
            get :index, params: { search: articles.first.body }
            expect(JSON.parse(response.body)["data"]).to_not be_empty
        end
      end
    end
    
    describe "GET #show" do
        context "return article with id" do
            it "return an article" do
                get :show, params: { id: articles.first.id }
                expect(JSON.parse(response.body)["data"]["id"]).to eq(articles.first.id)
            end
            it "article not found" do
                get :show, params: { id: -1 }
                expect(response.status).to eq(404)
            end
        end
    end

    describe "POST #create" do
        let(:title) { Faker::Name.name }
        let(:body) { Faker::Quote.famous_last_words }
        let(:article_id) { articles.first.id }
        let(:create_params) do
            {
                title: title,
                body: body,
                article_id: article_id 
            }
        end
        let(:params) { { article: create_params } }
        
        before do
            post :create, params: params
        end

        context "with valid params" do
            it "succeeds" do
                expect(JSON.parse(response.body)["data"]["body"]).to eq(body)
                expect(JSON.parse(response.body)["data"]["title"]).to eq(title)
                expect(response.status).to eq(201)
            end
        end

        context 'missing parameters' do
            %i[body title].each do |key|
                let(:params) { { article: create_params.except(key) } }
                it 'returns an error' do
                    expect(response).to have_http_status(422)
                end
            end
        end
    end

    describe "#PUT update" do
        let(:article_id) { articles.first.id }
        let(:updated_param) { "Updated body" }

        before do 
            put :update, params: { id: article_id, article: { body: updated_param } }
        end
        
        context "with valid params" do
            it "succeeds" do
                expect(JSON.parse(response.body)["data"]["body"]).to eq("Updated body")
            end
        end

        context "with invalid params" do
            let(:updated_param) { " " }
            it "error not found" do
                expect(JSON.parse(response.body)["data"]["body"]).to eq(["can't be blank"])
                expect(response.status).to eq(404)
            end
        end
    end

    describe "DELETE destroy" do
        let(:id) { articles.sample.id }
       
        before do 
            delete :destroy, params: { id: id }
        end
    
        context "when article exists" do    
          it "succeeds" do
            expect(JSON.parse(response.body)["data"]["id"]).to eq(id)
            expect(response).to have_http_status(204)
          end
        end
    
        context "when article does not exists" do
          let(:id) { -1 }
    
          it "error not found" do
            expect(response.status).to eq(404)
          end
        end
    end
end
