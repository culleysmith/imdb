require_relative 'page'

class ShowManager

  INCREMENT = 50
  START = 1

  attr_reader :country_code

  def self.run(country_code)
    new(country_code).run
  end

  def initialize
    @country_code = country_code
    @increment = 0
  end

  def run
    loop do
      page = Page.new(url)

      break if page.shows.empty?

      page.shows.each(&:add_row)

      @increment += INCREMENT
    end
  end

  def url
    start = START + @increment
    "https://www.imdb.com/search/title/?title_type=tv_series&countries=#{country_code}&start=#{start}&ref_=adv_nxt"
  end
end
