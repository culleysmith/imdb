require 'csv'
require_relative 'show'

class ShowQuery
  attr_reader :kwargs

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
    end.map { |row| ShowStruct.new(*row.fields) }
  end

  private

  def rows
    @_rows ||= CSV.read(SHOWS_FILE, headers: true, header_converters: :symbol)
  end
end
