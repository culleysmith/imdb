class GetMoreShowDetails
  attr_reader :show

  ExtendedDetails = Struct.new(*ShowStruct.members, :critic_count, :description, :popularity)

  CRITIC_COUNT_PATH = 'span.score'.freeze
  DESCRIPTION_PATH = '[data-testid="plot-l"]'.freeze
  POPULARITY_PATH = '[data-testid="hero-rating-bar__popularity__score"]'.freeze

  def initialize(show)
    @show = show
  end

  def add_row
    CsvWriter.add_row(struct)
  end

  def critic_count
    doc.css(CRITIC_COUNT_PATH).last.text.to_i
  end

  def description
    doc.css(DESCRIPTION_PATH).text
  end

  def popularity
    doc.css(POPULARITY_PATH).first.text.delete(',').to_i
  end

  def struct
    ExtendedDetails.new(*show.to_h.values, critic_count, description, popularity)
  end

  def body
    @_body ||= Faraday.get(show.url)&.body
  end

  def doc
    @_doc ||= Nokogiri::HTML.parse(body)
  end
end
