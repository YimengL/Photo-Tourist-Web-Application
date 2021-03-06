require 'rails_helper'
require 'support/foo_ui_helper.rb'

RSpec.feature "ManageFoos", type: :feature, :js => true do
  include_context "db_cleanup_each"
  include FooUiHelper
  FOO_FORM_XPATH = FooUiHelper::FOO_FORM_XPATH
  FOO_LIST_XPATH = FooUiHelper::FOO_LIST_XPATH

  feature "view existing Foos" do
    let(:foos) do
      (1..5).map { FactoryGirl.create(:foo) }.sort_by { |v| v["name"] }
    end

    it "when no instances exist" do
      visit root_path
      within(:xpath, FOO_LIST_XPATH) do     # <== waits for ul tag
        expect(page).to have_no_css("li")   # <== waits for ul li tag
        expect(page).to have_css("li", count: 0)   # <== waits for ul li tag
        expect(all("ul li").size).to eq(0)   # <== no wait
      end
    end

    it "when instances exist" do
      visit root_path if foos # need to touch collection before hitting page
      within(:xpath, FOO_LIST_XPATH) do
        expect(page).to have_css("li:nth-child(#{foos.count})") # waits for li(5)
        expect(page).to have_css("li", count: foos.count)   # waits for ul li tag
        expect(all("li").size).to eq(foos.count)  # no wait
        foos.each_with_index do |foo, idx|
          expect(page).to have_css("li:nth-child(#{idx+1})", :text => foo.name)
        end
      end
    end
  end

  feature "add new Foo" do
    let(:foo_state)   { FactoryGirl.attributes_for(:foo) }

    before(:each) do
      visit root_path
      expect(page).to have_css("h3", :text => "Foos") # on the Foos page
      within(:xpath, FOO_LIST_XPATH) do
        expect(page).to have_css("li", :count => 0)     # nothing listed
      end
    end

    it "has input form" do
      expect(page).to have_css("label", :text => "Name:")
      expect(page).to have_css("input[name='name'][ng-model='foosVM.foo.name']")
      expect(page).to have_css("button[ng-click='foosVM.create()']", :text =>
        "Create Foo")
      expect(page).to have_button("Create Foo")
    end

    it "complete form" do
      within(:xpath, FOO_FORM_XPATH) do
        fill_in("name", :with => foo_state[:name])
        click_button("Create Foo")
      end

      within(:xpath, FOO_LIST_XPATH) do
        expect(page).to have_css("li", :count => 1)
        expect(page).to have_content(foo_state[:name])
      end
    end

    it "complate form with XPath" do
      find(:xpath, "//input[contains(@ng-model, 'foo.name')]").
        set(foo_state[:name])
      find(:xpath, "//button[contains(@ng-click, 'foosVM.create()')]").click
      within(:xpath, FOO_LIST_XPATH) do
        expect(page).to have_xpath(".//li", :count => 1)
        expect(page).to have_content(foo_state[:name])
      end
    end

    it "complete form with helper" do
      create_foo foo_state

      within(:xpath, FOO_LIST_XPATH) do
        expect(page).to have_css("li", :count => 1)
      end
    end
  end

  feature "with existing Foo" do
    it "can be updated"
    it "can be deleted"
  end
end
