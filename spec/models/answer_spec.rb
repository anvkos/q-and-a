require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'has_user'
  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'association' do
    it { should belong_to(:question) }
  end

  describe 'validation' do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10) }
  end

  describe 'best answer' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it '#mark_best' do
      answer.mark_best
      expect(answer.reload).to be_best
    end

    it 'mark best another answer for question' do
      create(:answer, best: true, question: question)
      best_answer = create(:answer, question: question)
      best_answer.mark_best
      expect(best_answer.reload).to be_best
    end

    it 'best answer only one for question' do
      answers = create_list(:answer, 5, question: question)
      answers.each do |answer|
        answer.mark_best
        expect(answer.reload).to be_best
        expect(question.answers.where(best: true).count).to eq 1
      end
    end
  end

  describe '#first_best' do
    let(:question) { create(:question) }

    it 'first in the list' do
      answers = create_list(:answer, 5, question: question)
      third_answer = answers.third
      third_answer.update(best: true)
      expect(Answer.first_best.first).to eq third_answer
    end
  end
end
