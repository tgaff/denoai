require 'rails_helper'

RSpec.describe "chats/show", type: :view do
  before(:each) do
    assign(:chat, Chat.create!(
      title: "Title",
      library: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(//)
  end
end
