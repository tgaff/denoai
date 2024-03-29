require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/data_imports", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # DataImport. As you add validations to DataImport, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      DataImport.create! valid_attributes
      get data_imports_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      data_import = DataImport.create! valid_attributes
      get data_import_url(data_import)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_data_import_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      data_import = DataImport.create! valid_attributes
      get edit_data_import_url(data_import)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new DataImport" do
        expect {
          post data_imports_url, params: { data_import: valid_attributes }
        }.to change(DataImport, :count).by(1)
      end

      it "redirects to the created data_import" do
        post data_imports_url, params: { data_import: valid_attributes }
        expect(response).to redirect_to(data_import_url(DataImport.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new DataImport" do
        expect {
          post data_imports_url, params: { data_import: invalid_attributes }
        }.to change(DataImport, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post data_imports_url, params: { data_import: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested data_import" do
        data_import = DataImport.create! valid_attributes
        patch data_import_url(data_import), params: { data_import: new_attributes }
        data_import.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the data_import" do
        data_import = DataImport.create! valid_attributes
        patch data_import_url(data_import), params: { data_import: new_attributes }
        data_import.reload
        expect(response).to redirect_to(data_import_url(data_import))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        data_import = DataImport.create! valid_attributes
        patch data_import_url(data_import), params: { data_import: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested data_import" do
      data_import = DataImport.create! valid_attributes
      expect {
        delete data_import_url(data_import)
      }.to change(DataImport, :count).by(-1)
    end

    it "redirects to the data_imports list" do
      data_import = DataImport.create! valid_attributes
      delete data_import_url(data_import)
      expect(response).to redirect_to(data_imports_url)
    end
  end
end
