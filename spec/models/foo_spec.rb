require 'rails_helper'

describe Foo, type: :model do
  include_context "db_cleanup", :transaction
  include_context "db_scope"

  context "created Foo (let)" do
    let!(:before_count)  { Foo.count }
    let!(:foo)           { FactoryGirl.create(:foo, :name => "test") }

    it { expect(foo).to be_persisted }
    it { expect(foo.name).to eq("test") }
    it { expect(Foo.find(foo.id)).to_not be_nil }
    it { expect(Foo.count).to eq(before_count + 1) }
  end

end
