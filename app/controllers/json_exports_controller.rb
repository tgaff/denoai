class JsonExportsController < ApplicationController
  skip_before_action :authenticate
  before_action :authenticate_good_job

  layout false
  def index
    @libraries = Library.all.select(:id, :name)
  end


  def show
    set_library
  end

  # aka download
  def download
    set_library

    file = @library.to_export_json
    send_data( 
      file,
      type: 'application/json',
      filename: "#{@library.name}.json"
    )
  end

  private

  def set_library
    @library = Library.find(
      params.require(:library_id)
    )
  end
end
