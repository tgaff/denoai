require 'rails_helper'

RSpec.describe "data_imports/new", type: :view do
  before(:each) do
    assign(:data_import, DataImport.new())
  end

  it "renders new data_import form" do
    render

    assert_select "form[action=?][method=?]", data_imports_path, "post" do
    end
  end
end
