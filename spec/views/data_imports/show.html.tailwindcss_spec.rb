require 'rails_helper'

RSpec.describe "data_imports/show", type: :view do
  before(:each) do
    assign(:data_import, DataImport.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
