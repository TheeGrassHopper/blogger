FactoryBot.define do
    factory :comment do
      commenter { Faker::Name.name }
      body { Faker::Lorem.sentence }
      article { nil }
    end
end