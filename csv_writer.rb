require 'csv'

class CsvWriter
  attr_reader :show_struct

  def self.add_row(show_struct)
    new(show_struct).add_row
  end

  def initialize(show_struct)
    @show_struct = show_struct
  end

  def add_row
    CSV.open(SHOWS_FILE, 'a+') do |csv|
      csv << row
    end
  end

  def row
    show_struct.values.reverse
  end
end
