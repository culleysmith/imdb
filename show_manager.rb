require_relative 'page'

class ShowManager
  INCREMENT = 50
  MAX_INCREMENT = 500
  START = 1

  attr_reader :country_code

  def self.run(country_code)
    new(country_code).run
  end

  def initialize(country_code)
    @country_code = country_code
    @increment = 0
  end

  def run
    loop do
      page = Page.new(url)

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
    "https://www.imdb.com/search/title/?title_type=tv_series&countries=#{country_code}&start=#{start}"
  end
end
