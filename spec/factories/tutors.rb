FactoryBot.define do
  factory :tutor do
    name { "John Doe" }
    sequence(:email) { |n| "tutor#{n}@example.com" }
    association :course
  end
end
