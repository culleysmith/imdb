require 'csv'
require_relative 'show'

class Show
  attr_reader :kwargs

  SHOWS_FILE = 'shows.csv'.freeze

  def self.search(**kwargs)
    new(**kwargs).search
  end

  def initialize(**kwargs)
    @kwargs = kwargs
  end

  def search
    rows.select do |row|
      kwargs.all? do |field, term|
        if term.is_a?(Array)
          term.map(&:to_s).include?(row[field])
        else
          row[field] == term.to_s
        end
      end
    end.map { |row| ShowStruct.new(*row.fields.reverse) }
  end

  def rows
    @_rows ||= CSV.read(CSV_FILE, headers: true, header_converters: :symbol)
  end
end
