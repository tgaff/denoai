require 'rails_helper'

RSpec.describe "data_imports/edit", type: :view do
  let(:data_import) {
    DataImport.create!()
  }

  before(:each) do
    assign(:data_import, data_import)
  end

  it "renders the edit data_import form" do
    render

    assert_select "form[action=?][method=?]", data_import_path(data_import), "post" do
    end
  end
end
