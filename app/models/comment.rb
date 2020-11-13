class Comment < ApplicationRecord
    belongs_to :article
    validates_presence_of [:commenter, :body, :article_id], on: :create, message: "can't be blank"
end
