class JsonExportsController < ApplicationController
  skip_before_action :authenticate
  before_action :authenticate_good_job

  layout false
  def index
    @libraries = Library.all.select(:id, :name)
  end

  # aka download
  def download
    set_library
    
    # file = @library.texts.to_json
    # send_data( 
    #   file,
    #   filename: "#{@library.name}.json" 
    # )
  end

  private

  def set_library
    puts params.to_unsafe_hash
    @library = Library.find(
      params.require(:library_id)
    )
  end
end
