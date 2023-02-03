require 'awesome_print'

AwesomePrint.pry!
Pry.config.history_file = '.pry_history'

load 'page.rb'

def reload!
  load 'page.rb'
end
