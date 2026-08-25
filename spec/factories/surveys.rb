FactoryBot.define do
  factory :survey do
    sequence(:question) { |n| "Survey question ##{n}?" }
  end
end
