FactoryBot.define do
  factory :contact_form_submission do
    name { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    message { "MyText" }
    delivery_status { 1 }
    submitted_at { "2025-10-20 21:25:55" }
  end
end
