require_relative "warmup1.rb"
require 'pry'
def parser_script(file_name)
  root_node = Node.new("root")
  root_node.children = []
  cur_node = root_node
  File.readlines(file_name).each do |line|
    parsed_tag = parse_tag line
    if !parsed_tag.tag.nil?
      insert(cur_node, parsed_tag)
      cur_node = parsed_tag
    elsif !parsed_tag.close_tag.nil?
      cur_node = cur_node.parent
      insert(cur_node, parsed_tag)
    elsif !parsed_tag.text.nil?
      insert(cur_node, parsed_tag)
    end
  end
  root_node
end

def insert(root, node)
  root.children << node
  node.parent = root
end

def outputter(node, level)
  if node.tag == "root"
  elsif !node.tag.nil?
    puts "  "*level +"<#{node.tag}>"
  elsif !node.close_tag.nil?
    puts "  "*level + "</#{node.close_tag}>"
  elsif !node.text.nil?
    puts "  "*level + "#{node.text}"
  end
  node.children.each do |child|
    outputter(child, level+1)
  end
end


root = parser_script("sample.html")
outputter(root,-1)
