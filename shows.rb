class ShowsHelper
  def self.date_range(dates)
    start, finish = dates.split('..').map(&:to_i)
    Range.new(start, finish)
  end

  def self.genres(genre_string)
    genre_string.scan(/\w+/)
  end
end

Shows = CSV.read(SHOWS_FILE, headers: true, header_converters: :symbol).map do |row|
  ShowStruct.new(
    row[:country],
    ShowsHelper.date_range(row[:dates]),
    ShowsHelper.genres(row[:genres]),
    row[:score].to_f,
    row[:title],
    row[:url],
    row[:votes].to_i
  )
end.sort_by { |show| [show.votes, show.score] }
  .uniq(&:url)
  .reverse
  .freeze
