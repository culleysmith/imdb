require 'awesome_print'

AwesomePrint.pry!
Pry.config.history_file = '.pry_history'

SHOWS_FILE = 'shows.csv'.freeze

load 'country.rb'
load 'csv_writer.rb'
load 'show.rb'
load 'shows.rb'
load 'show_manager.rb'
load 'get_more_show_details.rb'

def reload!
  load 'country.rb'
  load 'csv_writer.rb'
  load 'get_more_show_details.rb'
  load 'show_manager.rb'
end
