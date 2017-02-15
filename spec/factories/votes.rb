FactoryGirl.define do
  factory :vote do
    user
    association :votable
    rating 1
  end
end
