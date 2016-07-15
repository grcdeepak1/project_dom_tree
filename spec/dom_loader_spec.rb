require_relative "../dom_loader.rb"

describe DOMLoader do
  describe "#initialize" do
    it "initialize returns a DOMLoader" do
      expect(subject).to be_a(DOMLoader)
    end
    it "DOMLoader has empty array by default" do
      expect(subject.dom_array.size).to eq(0)
    end
  end

  describe "#load" do
    it "loads sample file" do
      subject.load("sample.html")
      expect(subject.dom_array.size).to eq 13
    end
    it "loads test file" do
      subject.load("test.html")
      expect(subject.dom_array.size).to eq 43
    end
  end
end