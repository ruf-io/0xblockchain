FactoryBot.define do
  factory :comment do
    association :user
    association :story
    sequence(:comment) {|n| "comment text #{n}" }
    created_at { Time.now.utc }
  end
end
