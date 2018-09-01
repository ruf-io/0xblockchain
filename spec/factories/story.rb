FactoryBot.define do
  factory :story do
    association :user
    sequence(:title) {|n| "story title #{n}" }
    sequence(:url) {|n| "http://example.com/#{n}" }
    tag_names { ["tag1", "tag2"] }

    # Factory to create story with comments
    factory :story_with_comments do
      # posts_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        comments_count { 1 }
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |story, evaluator|
        create_list(:comment, evaluator.comments_count, story: story)
      end
    end
  end
end
