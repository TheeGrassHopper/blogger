# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

100.times do 
    article = Article.create(title: Faker::Name.unique.name, body: Faker::Movie.quote )
    2.times do
        article.comments.create(commenter: Faker::Name.name, body: Faker::Quote.famous_last_words)
    end
end
