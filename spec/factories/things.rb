FactoryGirl.define do
  factory :thing do
    name { Faker::Commerce.product_name }
    sequence(:description) do |n|
      n % 2 == 0 ? nil : Faker::Lorem.paragraphs.join
    end
    sequence(:notes) { |n| n % 2 == 1  ? nil : Faker::Lorem.paragraphs.join }

    trait :with_description do
      description { Faker::Lorem.paragraphs.join }
    end

    trait :with_notes do
      description { Faker::Lorem.paragraphs.join }
    end

    trait :with_image do
      transient do
        image_count 1
      end

      after(:build) do |thing, props|
        thing.thing_images << FactoryGirl.build_list(:thing_image,
                                                     props.image_count,
                                                     :thing => thing)
      end
    end
  end
end
