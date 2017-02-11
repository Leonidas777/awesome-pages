FactoryGirl.define do
  factory :page do
    sequence(:name)  { |n| "page_#{n}" }
    sequence(:title) { |n| "Title-#{n}" }
    description      { Faker::Lorem.paragraph(1) }

    factory :page_with_children do
      after(:create) do |page|
        2.times do
          (child = FactoryGirl.create(:page)).parent = page
          child.save!
        end
      end
    end
  end
end
