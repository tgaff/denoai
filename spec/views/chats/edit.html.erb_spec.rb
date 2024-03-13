require 'rails_helper'

RSpec.describe "chats/edit", type: :view do
  let(:chat) {
    Chat.create!(
      title: "MyString",
      library: nil
    )
  }

  before(:each) do
    assign(:chat, chat)
  end

  it "renders the edit chat form" do
    render

    assert_select "form[action=?][method=?]", chat_path(chat), "post" do

      assert_select "input[name=?]", "chat[title]"

      assert_select "input[name=?]", "chat[library_id]"
    end
  end
end
