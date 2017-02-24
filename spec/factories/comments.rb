FactoryGirl.define do
  sequence :content do |n|
    "Comment #{n} text"
  end

  factory :comment do
    content
    association :commentable
    user
  end
end
