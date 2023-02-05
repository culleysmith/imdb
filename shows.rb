ExtendedDetails = Struct.new(*ShowStruct.members, :critic_count, :description, :popularity)

class ShowsHelper
  def self.date_range(dates)
    start, finish = dates.split('..').map(&:to_i)
    Range.new(start, finish)
  end

  def self.genres(genre_string)
    genre_string.scan(/\w+/)
  end

  def self.format_description(description)
    words = description.split(' ')
    words.inject([]) do |final, word|
      if final.empty?
        final << word
      elsif (final.last + ' ' + word).size <= 75
        final.last << " #{word}"
      else
        final << word
      end
      final
    end.join("\n\t")
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

RecentPopularShows = Shows
  .reject do |show|
    show.score < 8.0 || show.votes < 2_000 || !show.date.end.nil? && show.date.last < 2019 || show.genres.any? { |genre| %w[Animation Biography Reality Talk Documentary].include?(genre) }
  end

Popular = CSV.read('recent_popular_shows.csv', headers: true, header_converters: :symbol)
  .reject { |row| row[:score].to_f < 8.0 || row[:critic_count].to_i <= 2 }.map do |row|
    description = ShowsHelper.format_description(row[:description])
    date = ShowsHelper.date_range(row[:dates])
    genres = ShowsHelper.genres(row[:genres]).join(', ')
  <<~SHOWS
    Title: #{row[:title]}

    \t#{description}

    \t============================================
    \t Date: #{date}
    \t Genres: #{genres}
    \t Critics: #{row[:critic_count].to_i}
    \t Popularity: #{row[:popularity].to_i}
    \t Score: #{row[:score].to_f}
    \t Votes: #{row[:votes].to_i}
    \t URL: #{row[:url]}
    \t============================================
  SHOWS
end.join("\n\n")

def preview_popular(pry_instance)
  Pry::Pager.new(pry_instance).page(Popular)
end
