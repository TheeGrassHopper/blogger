require 'rails_helper'
require 'shoulda'

describe Comment, type: :model do
    context "validations" do
        it { should belong_to(:article) }
        it { should validate_presence_of(:commenter) }
        it { should validate_presence_of(:body) }  
    end
end