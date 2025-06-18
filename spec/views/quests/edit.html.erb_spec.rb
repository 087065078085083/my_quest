require 'rails_helper'

RSpec.describe "quests/edit", type: :view do
  let(:quest) {
    Quest.create!(
      title: "MyString",
      description: "MyString",
      complete: false
    )
  }

  before(:each) do
    assign(:quest, quest)
  end

  it "renders the edit quest form" do
    render

    assert_select "form[action=?][method=?]", quest_path(quest), "post" do

      assert_select "input[name=?]", "quest[title]"

      assert_select "input[name=?]", "quest[description]"

      assert_select "input[name=?]", "quest[complete]"
    end
  end
end
