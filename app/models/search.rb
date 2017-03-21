class Search
  TYPES = %w(question answer comment user all).freeze

  def self.do(params = {})
    query = ThinkingSphinx::Query.escape(params[:q])
    page = params[:page].nil? ? 1 : params[:page]
    scopes = params[:scopes].nil? ? 'all' : params[:scopes]
    if scopes.include?('all')
      ThinkingSphinx.search(query, page: page)
    else
      classes = scopes.reject { |scope| scope unless TYPES.include?(scope) }
      classes.map! { |c| c.classify.constantize }
      if classes.present?
        ThinkingSphinx.search(query, classes: classes, page: page)
      end
    end
  end
end
