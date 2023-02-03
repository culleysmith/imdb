require 'awesome_print'

AwesomePrint.pry!
Pry.config.history_file = '.pry_history'

load 'country_codes.rb'
load 'csv_writer.rb'
load 'show_query.rb'
load 'show_manager.rb'

SHOWS_FILE = 'shows.csv'.freeze

def reload!
  load 'country_codes.rb'
  load 'csv_writer.rb'
  load 'show_query.rb'
  load 'show_manager.rb'
end
