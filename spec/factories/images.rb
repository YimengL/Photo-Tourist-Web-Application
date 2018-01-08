FactoryGirl.define do
  factory :image do
    sequence(:caption) do |n|
      n % 2 == 0 ? nil : Faker::Lorem.sentence(1).chomp(".")
    end
    creator_id 1

    trait :with_caption do
      caption { Faker::Lorem.sentence(1).chomp(".") }
    end
  end
end
