class Search
  TYPES = %w(question answer comment user all).freeze
  PER_PAGE = 5

  def self.do(params = {})
    query = ThinkingSphinx::Query.escape(params[:q])
    options = {
      page: params[:page].nil? ? 1 : params[:page],
      per_page: params[:per_page].nil? ? PER_PAGE : params[:per_page]
    }
    unless params[:scopes].nil? || params[:scopes].include?('all')
      classes = params[:scopes].reject { |scope| scope unless TYPES.include?(scope) }
      classes.map! { |c| c.classify.constantize }
      options[:classes] = classes if classes.present?
    end
    ThinkingSphinx.search(query, options)
  end
end
