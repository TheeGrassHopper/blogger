class Comment < ApplicationRecord
    belongs_to :article
    validates_presence_of [:commenter, :body], on: [:create, :update], message: "can't be blank"
end
