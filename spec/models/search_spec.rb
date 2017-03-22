require 'rails_helper'

RSpec.describe Search do
  describe '.do' do
    let(:params) { { q: 'search text', scopes: %w(question answer comment user)} }

    it 'escapes query' do
      expect(ThinkingSphinx::Query).to receive(:escape).with(params[:q])
      Search.do(params)
    end

    context 'scopes' do
      context 'scope all' do
        it 'set scope all' do
          params[:scopes] += ['all']
          expect(ThinkingSphinx).to receive(:search).with(params[:q], page: 1, per_page: 5)
          Search.do(params)
        end

        it 'default scope set all' do
          params[:scopes] = nil
          expect(ThinkingSphinx).to receive(:search).with(params[:q], page: 1, per_page: 5)
          Search.do(params)
        end
      end

      it 'classify scope' do
        classes = params[:scopes].map { |scope| scope.classify.constantize }
        expect(ThinkingSphinx).to receive(:search).with(params[:q], classes: classes, page: 1, per_page: 5)
        Search.do(params)
      end

      context 'pages' do
        let(:params) { { q: 'search text', scopes: ['all'] } }

        it 'default page 1' do
          expect(ThinkingSphinx).to receive(:search).with(params[:q], page: 1, per_page: 5)
          Search.do(params)
        end

        it 'set page' do
          params[:page] = rand(1..10)
          expect(ThinkingSphinx).to receive(:search).with(params[:q], page: params[:page], per_page: 5)
          Search.do(params)
        end
      end
    end
  end
end
