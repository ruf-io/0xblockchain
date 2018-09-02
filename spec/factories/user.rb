FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "user-#{n}@example.com" }
    sequence(:username) {|n| "username#{n}" }
    sequence(:github_uid) {|n| "1234#{n}" }
    sequence(:github_oauth_token) {|n| "1234#{n}" }

    # password { "blah blah" }
    # password_confirmation(&:password)
    trait(:banned) do
      transient do
        banner { nil }
      end
      banned_at { Time.now.utc }
      banned_reason { "some reason" }
      banned_by_user_id { banner && banner.id }
    end
    trait(:noinvite) do
      transient do
        disabler { nil }
      end
      disabled_invite_at { Time.now.utc }
      disabled_invite_reason { "some reason" }
      disabled_invite_by_user_id { disabler && disabler.id }
    end
    trait(:inactive) do
      username { 'inactive-user' }
      to_create {|user| user.save(validate: false) }
    end
    trait(:admin) do
      is_admin { true }
      is_moderator { true }
    end
    trait(:moderator) do
      is_moderator { true }
    end
  end
end
