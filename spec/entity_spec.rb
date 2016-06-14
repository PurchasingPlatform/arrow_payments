class EntityTester < ArrowPayments::Entity
  property :foo,     from: "Foo"
  property :foobar,  from: "Foobar"
  property :foo_bar, from: "FooBar"
end

describe ArrowPayments::Entity do
  let(:attributes) do
    {"Foo" => "a", "Foobar" => "b", "FooBar" => "c"}
  end

  describe "#new" do
    it "assigns properties" do
      entity = EntityTester.new(attributes)

      expect(entity.foo).to eq("a")
      expect(entity.foobar).to eq("b")
      expect(entity.foo_bar).to eq("c")
    end

    it "ignores undefined attributes" do
      entity = EntityTester.new(attributes.merge("Bro" => "Sup?"))

      expect { entity.foo }.not_to raise_error
      expect { entity["Bro"] }.to raise_error NoMethodError
    end
  end

  describe "#properties_map" do
    it "returns hash with property mappings" do
      map = EntityTester.properties_map

      expect(map).to be_a Hash
      expect(map).to_not be_empty
      expect(map.keys).to include(:foo, :foobar, :foo_bar)
      expect(map[:foo]).to eq("Foo")
      expect(map[:foobar]).to eq("Foobar")
      expect(map[:foo_bar]).to eq("FooBar")
    end
  end

  describe "#to_source_hash" do
    it "returns hash as source format" do
      entity = EntityTester.new(attributes)
      hash = entity.to_source_hash

      expect(hash.size).to eq(3)
      expect(hash["Foo"]).to eq("a")
      expect(hash["Foobar"]).to eq("b")
      expect(hash["FooBar"]).to eq("c")
    end
  end
end
