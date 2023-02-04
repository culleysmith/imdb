require 'faraday'
require 'nokogiri'

class Page
  attr_reader :country, :url

  SHOWS_PATH = 'div.lister-item.mode-advanced'.freeze

  def initialize(url, country)
    @country = country
    @url = url
  end

  def shows
    return [] unless body

    @_shows ||= doc.css(SHOWS_PATH).map { |section| Show.new(section, country) }
  end

  private

  def body
    @_body ||= Faraday.get(url)&.body
  end

  def doc
    @_doc ||= Nokogiri::HTML.parse(body)
  end
end
