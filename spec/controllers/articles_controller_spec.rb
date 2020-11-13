require 'rails_helper'


describe ArticlesController, type: :controller do
    let!(:articles) { FactoryBot.create_list(:article, 10) }

    describe "GET #index" do
      context "return all articles" do
        before do
            get :index
        end
  
        it "returns all articles paginated limit 10" do
          expect(JSON.parse(response.body).count).to eq(articles.count)
        end
      end
    end
end
