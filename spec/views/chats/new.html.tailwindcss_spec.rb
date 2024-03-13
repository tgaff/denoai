require 'rails_helper'

RSpec.describe "chats/new", type: :view do
  before(:each) do
    assign(:chat, Chat.new(
      title: "MyString",
      library: nil
    ))
  end

  it "renders new chat form" do
    render

    assert_select "form[action=?][method=?]", chats_path, "post" do

      assert_select "input[name=?]", "chat[title]"

      assert_select "input[name=?]", "chat[library_id]"
    end
  end
end
