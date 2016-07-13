require 'pry'
Node  = Struct.new(:tag, :classes, :name, :id, :src, :title)

def parse_tag(str)
  node = Node.new
  tag = str.match(/<(\w*)/)
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
  end
end

p tag = parse_tag("<p class='foo bar' id='baz'>")
p tag = parse_tag("<p clas='foo bar' id='baz' name='fozzie'>")
p tag = parse_tag("<div id = 'bim'>")
p tag = parse_tag("<img src='http://www.example.com' title='funny things'>")
p tag.src