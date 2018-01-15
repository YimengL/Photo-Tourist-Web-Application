require 'rails_helper'

RSpec.describe "Things", type: :request do
  include_context "db_cleanup_each"
  let(:account)   { signup FactoryGirl.attributes_for(:user) }

  context "quick API check" do
    let!(:user)   { login account }
    it_should_behave_like "resource index", :thing
    it_should_behave_like "show resource", :thing
    it_should_behave_like "create resource", :thing
    it_should_behave_like "modifiable resource", :thing
  end

  shared_examples "cannot create" do
    it "create fails" do
      jpost things_path, thing_props
      expect(response.status).to be >= 400
      expect(response.status).to be < 500
      expect(parsed_body).to include("errors")
    end
  end

  shared_examples "can create" do
    it "can create" do
      jpost things_path, thing_props
      expect(response).to have_http_status(:created)
      payload = parsed_body
      expect(payload).to include("id")
      expect(payload).to include("description" => thing_props[:description])
      expect(payload).to include("notes" => thing_props[:notes])
    end
  end

  shared_examples "all fields present" do
    it "list has all fields" do
      jget things_path
      expect(response).to have_http_status(:ok)
      # pp parsed_body
      payload = parsed_body
      expect(payload.size).to_not eq(0)
      payload.each do |r|
        expect(r).to include("id")
        expect(r).to include("description")
        expect(r).to include("notes")
      end
    end

    it "get has all fields" do
      jget thing_path(thing.id)
      expect(response).to have_http_status(:ok)
      # pp parsed_body
      payload = parsed_body
      expect(payload).to include("id" => thing.id)
      expect(payload).to include("description" => thing.description)
      expect(payload).to include("notes" => thing.notes)
    end
  end

  describe "access" do
    let(:things_props) do
      (1..3).map { FactoryGirl.attributes_for(:thing, :with_description,
        :with_notes) }
    end
    let(:thing_props)   { things_props[0] }
    let!(:things)       { Thing.create(things_props) }
    let(:thing)         { things[0] }

    context "unauthenticated caller" do
      before(:each)   { logout nil }
      it_should_behave_like "cannot create"
      it_should_behave_like "all fields present"
    end

    context "authenticated caller" do
      let!(:user)   { login account }
      it_should_behave_like "can create"
      it_should_behave_like "all fields present"
    end
  end
end
