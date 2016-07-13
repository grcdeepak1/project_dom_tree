require 'pry'
Node  = Struct.new(:tag, :close_tag, :classes, :name, :id, :src, :title, :text, :children, :parent)

def parse_tag(str)
  node = Node.new
  tag = str.match(/<(\w*)/)
  close_tag = str.match(/<\/(\w*)/)
  classes = str.match(/class\s*=\s*'([\w\s]*)/)
  name = str.match(/name\s*=\s*'([\w\s]*)/)
  id = str.match(/id\s*=\s*'([\w\s]*)/)
  src = str.match(/src\s*=\s*'(.*?)'/)
  title = str.match(/title\s*=\s*'(.*?)'/)
  node.each do |field|
    node.children = []
    node.tag = tag[1] if !tag.nil?
    node.classes = classes[1].split(" ").to_a if !classes.nil?
    node.name = name[1] if !name.nil?
    node.id = id[1] if !id.nil?
    node.src = src[1] if !src.nil?
    node.title = title[1] if !title.nil?
    node.close_tag = close_tag[1] if !close_tag.nil?
    node.tag = nil if !close_tag.nil?
  end
  if node.all? { |field| field == nil || field.empty? }
    node.text = str.strip if !str.empty?
  end
  node
end

# p tag = parse_tag("<p class='foo bar' id='baz'>")
# p tag = parse_tag("<p clas='foo bar' id='baz' name='fozzie'>")
# p tag = parse_tag("<div id = 'bim'>")
# p tag = parse_tag("<img src='http://www.example.com' title='funny things'>")
# p tag = parse_tag("<div>")
# p tag = parse_tag("</div>")
# p tag = parse_tag("hello")
