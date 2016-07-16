require_relative "dom_loader.rb"
require_relative "dom_reader.rb"
require_relative "dom_render.rb"

class DOMSearcher
  attr_reader :root
  def initialize(tree)
    @root = tree
  end


  def search_by(symbol, field)
    result = []
    search(root, symbol, field, result)
    result
  end

  def search_descendents(node, symbol, field)
    result = []
    node.children.each do |child|
      search(child, symbol, field, result)
    end
    result
  end

  def search_ancestors(node, symbol, field)
    result = []
    search_node(node.parent, symbol, field, result)
    result
  end

  def search(node, symbol, field, result = [])
    return if node == nil
    result << node if node[symbol] && node[symbol].include?(field)
    node.children.each do |child|
      search(child, symbol, field, result)
    end
  end

  def search_node(node, symbol, field, result = [])
    return if node == nil
    result << node if node[symbol] && node[symbol].include?(field)
  end

end

# dom_array = DOMLoader.new.load("sample.html")
# dom_reader = DOMReader.new
# dom_tree = dom_reader.build_tree(dom_array)
# renderer = DOMRender.new(dom_tree)
# searcher = DOMSearcher.new(dom_tree)
# sidebars = searcher.search_by(:classes, "sidebar")
# sidebars.each { |node| renderer.render(node) }
# amazing = searcher.search_by(:id, "amazing")
# amazing = searcher.search_descendents(searcher.root.children[0], :id, "amazing")
# amazing = searcher.search_ancestors(searcher.root.children[0].children[0], :id, "amazing")
# amazing.each { |node| renderer.render(node) }