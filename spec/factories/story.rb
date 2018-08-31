FactoryBot.define do
  factory :story do
    association(:user)
    sequence(:title) {|n| "story title #{n}" }
    sequence(:url) {|n| "http://example.com/#{n}" }
    tag_names { ["tag1", "tag2"] }
  end
end
