require 'rails_helper'

RSpec.describe "data_imports/index", type: :view do
  before(:each) do
    assign(:data_imports, [
      DataImport.create!(),
      DataImport.create!()
    ])
  end

  it "renders a list of data_imports" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
