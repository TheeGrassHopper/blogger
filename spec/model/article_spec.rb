require 'rails_helper'
require 'shoulda'

describe Article, type: :model do
    context "validations" do
        it { should have_many(:comments) }
        it { should validate_presence_of(:title) }
        it { should validate_presence_of(:body) }
    end
end
