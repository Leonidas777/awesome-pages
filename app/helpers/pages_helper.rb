module PagesHelper
  def nested_page_path(page)
    '/' + (page.ancestors + [page]).map(&:to_param).join('/')
  end

  def add_page_to(page)
    nested_page_path(page) + '/add'
  end

  def edit_page(page)
    nested_page_path(page) + '/edit'
  end

  def slug_of(page)
    page.present? ? page.slug : ''
  end

  def parse_description_of(page)
    regexp = /\*\*(.*)\*\*|\\\\(.*)\\\\|\(\((.+)\s(([a-z0-9_]+\/?[^\/])*)\)\)/

    page.description.gsub(regexp) do |string|
      case string
      when /\*\*(.*)\*\*/
        "<b>#{$1}</b>"
      when /\\\\(.*)\\\\/
        "<i>#{$1}</i>"
      when /\(\((.+)\s(([a-z0-9_]+\/?[^\/])*)\)\)/
        "<a href='#{request.protocol}#{request.host_with_port}/#{$2}'>#{$1}</a>"
      end
    end
  end
end
