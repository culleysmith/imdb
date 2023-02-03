require 'faraday'
require 'nokogiri'

class Page
  attr_reader :url

  COUNTRY_PATH = 'div.article h1.header'.freeze
  SHOWS_PATH = 'div.lister-item.mode-advanced'.freeze

  def initialize(url)
    @url = url
  end

  def shows
    return [] unless body

    @_shows ||= begin
                  doc.css(SHOWS_PATH).map do |section|
                    Show.new(section, country: country)
                  end
                end
  end

  private

  def body
    @_body ||= Faraday.get(url)&.body
  end

  def country
    @_country ||= doc.css(COUNTRY_PATH).text.split("\n")[1]
  end

  def doc
    @_doc ||= Nokogiri::HTML.parse(body)
  end
end
