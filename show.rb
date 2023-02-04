require_relative 'csv_writer'

ShowStruct = Struct.new(:country, :date, :genres, :score, :title, :url, :votes)
ShowBrief = Struct.new(:date, :genres, :score, :title, :url, :votes)

class Show
  attr_reader :country, :section

  DATE_PATH = 'span.lister-item-year'.freeze
  GENRES_PATH = 'span.genre'.freeze
  SCORE_PATH = 'div.ratings-imdb-rating strong'.freeze
  TITLE_PATH = 'h3.lister-item-header a'.freeze
  VOTES_PATH = 'p.sort-num_votes-visible span[name="nv"]'.freeze

  def initialize(section, country)
    @country = country
    @section = section
  end

  def add_row
    CsvWriter.add_row(struct)
  end

  def struct
    ShowStruct.new(country.name, date, genres, score, title, url, votes)
  end

  private

  def date
    datestring = section.css(DATE_PATH).text
    dates = datestring.scan(/\d{4}/).map(&:to_i)

    return Range.new(*dates) if dates.size == 2

    Range.new(dates.first, nil)
  end

  def genres
    section.css(GENRES_PATH).text.strip.split(', ')
  end

  def score
    section.css(SCORE_PATH).text.to_f
  end

  def title
    section.css(TITLE_PATH).text
  end

  def url
    href = section.css(TITLE_PATH).attribute('href').value
    uri = URI.parse("https://imdb.com#{href}")
    uri.fragment = uri.query = nil
    uri.to_s
  end

  def votes
    section.css(VOTES_PATH).attribute('data-value')&.value.to_i
  end
end
