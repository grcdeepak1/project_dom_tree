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

Node  = Struct.new(:tag, :close_tag, :classes, :name, :id, :src, :title, :text, :children, :parent)
class Node
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

  def initialize
    @root = Node.new("document")
  end

  def build_tree(path)

  end
end

tree = DOMReader.new
p tree