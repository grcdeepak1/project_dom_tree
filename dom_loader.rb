require 'pry'
class DOMLoader
  attr_reader :dom_array
  def initialize
    @dom_array = []
  end

  def load(path)
    begin
      File.readlines(path).each do |line|
      @dom_array << line
    end
      # puts "File was successfully loaded from #{path}"
      # puts "Your dom_array contains #{@dom_array.size} entries"
    rescue
      puts "Wrong filename #{path}, please try again with a valid file"
    end
    @dom_array
  end
end

# p DOMLoader.new.load("test.html")