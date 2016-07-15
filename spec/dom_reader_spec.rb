require_relative "../dom_reader.rb"

describe DOMReader do
  describe "#initialize" do
    it "initialize returns a DOMReader" do
      expect(subject).to be_a(DOMReader)
    end
    it "DOMReader creates a rootnode with document tag" do
      expect(subject.root.tag).to eq("document")
    end
  end
  describe "#parse_line" do
    it "p tag, class, id" do
      node = subject.parse_line("<p class='foo bar' id='baz'>")
      expected_node = Node.new
      expected_node.tag = "p"
      expected_node.classes = ['foo', 'bar']
      expected_node.id = "baz"
      expect(node).to eq(expected_node)
    end
    it "img tag, src, title" do
      node = subject.parse_line("<img src='http://www.example.com' title='funny things'>")
      expected_node = Node.new
      expected_node.tag = "img"
      expected_node.src = "http://www.example.com"
      expected_node.title = "funny things"
      expect(node).to eq(expected_node)
    end
    it "inline tags with text" do
      nodes = subject.parse_line("I'm an inner div!!! I might just <em>emphasize</em> some text.")
      expect(nodes.size).to eq(5)
    end
    it "compares nodes[0] with inline tags" do
      nodes = subject.parse_line("I'm an inner div!!! I might just <em>emphasize</em> some text.")
      node0 = Node.new
      node0.text = "I'm an inner div!!! I might just"
      node0.inline = true
      expect(nodes[0]).to eq(node0)
    end
    it "compares nodes[1] with inline tags" do
      nodes = subject.parse_line("I'm an inner div!!! I might just <em>emphasize</em> some text.")
      node1 = Node.new
      node1.tag = "em"
      node1.inline = true
      expect(nodes[1]).to eq(node1)
    end
    it "compares nodes[2] with inline tags" do
      nodes = subject.parse_line("I'm an inner div!!! I might just <em>emphasize</em> some text.")
      node2 = Node.new
      node2.text = "emphasize"
      node2.inline = true
      expect(nodes[2]).to eq(node2)
    end

    it "compares nodes[3] with inline tags" do
      nodes = subject.parse_line("I'm an inner div!!! I might just <em>emphasize</em> some text.")
      node3 = Node.new
      node3.close_tag = "em"
      node3.inline = true
      expect(nodes[3]).to eq(node3)
    end

    it "compares nodes[4] with inline tags" do
      nodes = subject.parse_line("I'm an inner div!!! I might just <em>emphasize</em> some text.")
      node4 = Node.new
      node4.text = "some text."
      node4.inline = false
      expect(nodes[4]).to eq(node4)
    end
  end

  describe "#insert_node" do
    it "insert text node after tag node" do
      tag_node = Node.new
      tag_node.tag = "p"
      text_node = Node.new
      text_node.text = "hello"
      expect(subject.insert_node(tag_node, text_node)).to eq(tag_node)
    end
    it "insert text node after close_tag" do
      close_tag_node = Node.new
      close_tag_node.close_tag = "p"
      text_node = Node.new
      text_node.text = "hello"
      expect(subject.insert_node(close_tag_node, text_node)).to eq(close_tag_node)
    end
    it "insert close_tag after tag node" do
      tag_node = Node.new
      tag_node.tag = "p"
      close_tag_node = Node.new
      close_tag_node.close_tag = "p"
      tag_parent_node = Node.new
      subject.insert(tag_parent_node, tag_node)
      expect(subject.insert_node(tag_node, close_tag_node)).to eq(tag_parent_node)
    end
    it "insert close_tag after text node" do
      text_node = Node.new
      text_node.text = "hello"
      close_tag_node = Node.new
      close_tag_node.close_tag = "p"
      tag_parent_node = Node.new
      subject.insert(tag_parent_node, text_node)
      expect(subject.insert_node(text_node, close_tag_node)).to eq(tag_parent_node)
    end
    it "insert tag node after text" do
      text_node = Node.new
      text_node.text = "hello"
      tag_node = Node.new
      tag_node.tag = "p"
      tag_parent_node = Node.new
      subject.insert(tag_parent_node, text_node)
      expect(subject.insert_node(tag_parent_node, tag_node)).to eq(tag_node)
    end
    it "insert tag node after close_tag" do
      close_tag_node = Node.new
      close_tag_node.close_tag = "p"
      tag_node = Node.new
      tag_node.tag = "p"
      tag_parent_node = Node.new
      subject.insert(tag_parent_node, close_tag_node)
      expect(subject.insert_node(tag_parent_node, tag_node)).to eq(tag_node)
    end
  end
end