require_relative "dom_loader.rb"
require_relative "dom_reader.rb"
class DOMRender
  attr_reader :root
  def initialize(tree)
    @root = tree
  end

  def render(node = @root)
    puts "Subtree contains - #{count_subtree(node, 0)} Nodes"
    puts "Subtree contains the following tags"
    p scan_tags(node, {})
    puts "Current Node : #{node}"
  end

  def count_subtree(node, count)
    return 0 if node == nil
    node.children.each { |child| count = 1 + count_subtree(child, count) }
    count
  end

  def scan_tags(node, dict)
    return if node == nil
    dict[node.tag] ? dict[node.tag] += 1 : dict[node.tag] = 1 if !node.tag.nil?
    dict['/'+node.close_tag] ? dict['/'+node.close_tag] += 1 : dict['/'+node.close_tag] = 1 if !node.close_tag.nil?
    dict["text"] ? dict["text"] += 1 : dict["text"] = 1 if !node.text.nil?
    node.children.each do |child|
      scan_tags(child, dict)
    end
    dict
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


dom_array = DOMLoader.new.load("sample.html")
dom_reader = DOMReader.new
dom_tree = dom_reader.build_tree(dom_array)

renderer = DOMRender.new(dom_tree)
renderer.render(renderer.root.children[0])

# renderer.outputter(renderer.root, -1)