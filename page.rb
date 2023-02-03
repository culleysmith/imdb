require 'faraday'
require 'nokogiri'
require_relative 'show'

class Page
  attr_reader :url

  CSS_PATH = 'div.lister-item.mode-advanced'.freeze

  def initialize(url)
    @url = url
  end

  def shows
    return unless body

    @_shows ||= doc.map { |item| Show.new(item).struct }
  end

  def body
    @_body ||= Faraday.get(url)&.body
  end

  def doc
    Nokogiri::HTML.parse(body).css(CSS_PATH)
  end
end
