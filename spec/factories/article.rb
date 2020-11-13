FactoryBot.define do
    factory :article do
      title do
        t = ""
        t = Faker::Book.title until t.length >= 10
        t
      end     
      body { Faker::Lorem.sentence }
    end
end