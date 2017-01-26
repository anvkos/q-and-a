FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question #{n} title" }
    sequence(:body) { |n| "Question #{n} text" }
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
