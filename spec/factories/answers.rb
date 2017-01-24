FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n} text"
  end

  factory :answer do
    body
    question nil
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
