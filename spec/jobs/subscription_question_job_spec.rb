require 'rails_helper'

RSpec.describe SubscriptionQuestionJob, type: :job do
  let(:question) { create(:question) }
  let(:subscriptions) { create_list(:subscription, 2, question: question) }
  let(:subscribers) { [question.user] + subscriptions.map(&:user) }
  let!(:answer) { create(:answer, question: question) }

  it 'Users are notified by mail about a new reply' do
    subscribers.each do |user|
      expect(SubscriptionQuestionMailer).to receive(:notify).with(user, answer).and_call_original
    end
    SubscriptionQuestionJob.perform_now(answer)
  end
end
