# Psuedo code
# DOMUI class will handle the UI related ops
# DOMLoader class will handle file related ops and populate a dom_array
# DOMReader class will parse the array and build the data structure and return a dom_tree
# 1. DOMReader will convert each element of dom_array into a Node and add it to the dom_tree
# 2. If both tags and close_tags are present in the same line, that line is processed by inline_tag_process method
# 3. inline_tag_process method, splits the line in sections and creates nodes using the sections.
# 4. All the nodes created in inline_tag_process method is created with inline_tag true, except the last one (print instead of puts)
# DOMRender class will handle rending of the dom_tree on the console
# DOMSearch class will handle all the search functions
require 'pry'
require_relative "dom_loader.rb"

class Node  < Struct.new(:tag, :close_tag, :classes, :name, :id, :src, :title, :text, :inline, :children, :parent)
  def to_s
    if !tag.nil?
      str = "tag - #{tag}"
      str += "\tclasses - #{classes}" if !classes.nil?
      str += "\tid - #{id}" if !id.nil?
      str
    elsif !close_tag.nil?
      "close_tag - #{close_tag}"
    else
      "text - #{text}"
    end
  end
  class << self
    alias_method :old_new, :new
    def new(*args)
      obj = old_new(*args)
      obj.children = []
      obj
    end
  end
end

class DOMReader
  attr_reader :root
  def initialize
    @root = Node.new("document")
  end

  def build_tree(dom_array)
    cur_node = @root
    dom_array.each do |line|
      node = parse_line(line)
      if node.kind_of?(Array)
        node.each { |n| cur_node = insert_node(cur_node, n) }
      else
        cur_node = insert_node(cur_node, node)
      end
    end
    @root
  end

  def insert(root, node)
    root.children << node
    node.parent = root
  end

  def insert_node(cur_node, node)
    if !node.tag.nil?
      insert(cur_node, node)
      cur_node = node
    elsif !node.close_tag.nil?
      cur_node = cur_node.parent
      insert(cur_node, node)
      cur_node
    elsif !node.text.nil?
      insert(cur_node, node)
      cur_node
    end
  end

  def parse_line(str)
    node = Node.new
    tag = str.match(/<(\w*)/)
    close_tag = str.match(/<\/(\w*)/)
    classes = str.match(/class\s*=\s*'([\w\s]*)/)
    name = str.match(/name\s*=\s*'([\w\s]*)/)
    id = str.match(/id\s*=\s*'([\w\s]*)/)
    src = str.match(/src\s*=\s*'(.*?)'/)
    title = str.match(/title\s*=\s*'(.*?)'/)
    node.each do |field|
      node.tag = tag[1] if !tag.nil?
      node.classes = classes[1].split(" ").to_a if !classes.nil?
      node.name = name[1] if !name.nil?
      node.id = id[1] if !id.nil?
      node.src = src[1] if !src.nil?
      node.title = title[1] if !title.nil?
      node.close_tag = close_tag[1] if !close_tag.nil?
      node.tag = nil if node.tag == ""
    end
    if node.all? { |field| field == nil || field.empty? }
      node.text = str.strip if !str.empty?
    end
    if !node.tag.nil? && !node.close_tag.nil?
      inline_tag_process(str)
    else
      node
    end
  end

  def inline_tag_process(str)
    arr = []
    str.split(/(<.*?>)/).each do |line|
      node = parse_line(line)
      node.inline = true
      arr << node
    end
    arr.last.inline = false
    arr.first.inline = :inline_first
    arr
  end

  def outputter(node, level)
    if node.tag == "document"
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

end

# dom_array = DOMLoader.new.load("sample.html")
# dom_reader = DOMReader.new
# dom_reader.build_tree(dom_array)
# puts
# # dom_reader.outputter(dom_reader.root, -1)
# # str = "Before text <span>mid text (not included in text attribute of the paragraph tag)</span> after text."
# # p dom_reader.parse_line(str)
# # arr = dom_reader.inline_tag_process(str)
# # p arr
# # puts


