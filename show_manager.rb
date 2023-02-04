require_relative 'page'

class ShowManager
  INCREMENT = 50
  MAX_INCREMENT = 500
  START = 1

  attr_reader :country

  def self.run(country)
    new(country).run
  end

  def initialize(country)
    @country = country
    @increment = 0
  end

  def run
    loop do
      page = Page.new(url, country)

      break if reached_max?

      $stdout.puts message

      page.shows.each(&:add_row)

      @increment += INCREMENT
    end
  end

  private

  def message
    "Adding #{@increment + INCREMENT} out of #{MAX_INCREMENT} shows."
  end

  def reached_max?
    @increment >= MAX_INCREMENT
  end

  def url
    start = START + @increment
    "https://www.imdb.com/search/title/?title_type=tv_series&countries=#{country.abbr}&start=#{start}"
  end
end
