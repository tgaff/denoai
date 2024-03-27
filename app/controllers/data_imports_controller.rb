class DataImportsController < ApplicationController
  skip_before_action :authenticate
  before_action :authenticate_good_job

  # GET /data_imports
  def index
    
  end

  # GET /data_imports/1
  def show
  end

  # GET /data_imports/new
  def new
    @data_import = DataImport.new
  end

  # GET /data_imports/1/edit
  def edit
  end


  ALLOWED_WORK_MAPPINGS = {
    markdown: ScanLzGuidesJob,
  }
  # POST /data_imports
  def create
    task = ALLOWED_WORK_MAPPINGS[data_import_params&.to_sym]
    if task.present?
      task.perform_later
      redirect_to data_imports_path, notice: "Task enqueued"
    else
      render :index, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /data_imports/1
  def update
    if @data_import.update(data_import_params)
      redirect_to @data_import, notice: "Data import was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /data_imports/1
  def destroy
    @data_import.destroy!
    redirect_to data_imports_url, notice: "Data import was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_import
      @data_import = DataImport.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def data_import_params
      params.fetch(:task)
    end

    def authenticate_good_job
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.application.credentials.dig(:good_job, :username) &&
          password == Rails.application.credentials.dig(:good_job, :password)
      end
    end  
end
