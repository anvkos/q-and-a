class SearchesController < ApplicationController
  def show
    if search_params.present?
      @result = Search.do(search_params)
      respond_with(@result)
    end
  end

  private

  def search_params
    params.permit(:q, :page, :per_page, scopes: [])
  end
end
