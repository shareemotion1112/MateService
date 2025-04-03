FactoryBot.define do
  factory :project do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    user { nil }
  end
end
