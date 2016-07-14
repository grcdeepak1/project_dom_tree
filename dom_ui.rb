require_relative "dom_loader.rb"
require_relative "dom_reader.rb"
require_relative "dom_search.rb"
require_relative "dom_render.rb"

class DOMUI

  def run
    path = file_path
  end

  def file_path
    puts "Enter the html file path, ('q' to quit)"
    ip = gets.chomp
    exit if ip == 'q'
    ip
  end

end