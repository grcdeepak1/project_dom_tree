require_relative "../dom_search.rb"

describe DOMSearcher do
  before(:each) do
    dom_array = DOMLoader.new.load("sample.html")
    dom_reader = DOMReader.new
    dom_tree = dom_reader.build_tree(dom_array)
    @searcher = DOMSearcher.new(dom_tree)
  end
  describe "#initialize" do
    it "initialize returns a DOMSearcher" do
      expect(@searcher).to be_a(DOMSearcher)
    end
  end

  describe "#search_by" do
    it "seachs for classes" do
      sidebars = @searcher.search_by(:classes, "sidebar")
      expect(sidebars.size).to eq(2)
    end

    it "searchs for id" do
      amazing = @searcher.search_by(:id, "amazing")
      expect(amazing.size).to eq(1)
    end
  end

  describe "#search_ancestors" do
    it "searches for id in parent" do
      amazing = @searcher.search_ancestors(@searcher.root.children[0].children[0], :id, "amazing")
      expect(amazing.size).to eq(1)
    end
  end

  describe "#search_descendents" do
    it "searches for id in descendents" do
      amazing = @searcher.search_descendents(@searcher.root.children[0], :id, "amazing")
      expect(amazing.size).to eq(0)
    end
  end
end