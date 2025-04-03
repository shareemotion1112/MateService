FactoryBot.define do
  factory :message do
    content { "MyText" }
    read_at { "2025-04-02 09:33:18" }
    user { nil }
  end
end
