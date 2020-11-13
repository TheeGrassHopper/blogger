class Article < ApplicationRecord
    has_many :comments
    
    validates_presence_of [:title, :body], on: :create, message: "can't be blank"
    validates_length_of :title, :minimum => 10

    def search text
        title.include?(text) || body.include?(text)
    end 
end
