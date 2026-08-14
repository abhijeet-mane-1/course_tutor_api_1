module Api::Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  private

  def current_page
    page = params.dig(:page, :number).to_i

    page.positive? ? page : DEFAULT_PAGE
  end

  def per_page
    requested_per_page = params.dig(:page, :size).to_i

    return DEFAULT_PER_PAGE if requested_per_page <= 0

    [requested_per_page, MAX_PER_PAGE].min
  end

  def pagination_offset
    (current_page - 1) * per_page
  end

  def pagination_meta(total_count)
    {
      current_page: current_page,
      per_page: per_page,
      total_pages: (total_count.to_f / per_page).ceil,
      total_count: total_count
    }
  end
end
