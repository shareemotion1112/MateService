FactoryBot.define do
  factory :team_member do
    user { nil }
    project { nil }
    role { "MyString" }
    status { "MyString" }
  end
end
