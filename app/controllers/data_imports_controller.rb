class DataImportsController < ApplicationController
  skip_before_action :authenticate
  before_action :authenticate_good_job

  # GET /data_imports
  def index
    @libraries = Library.all.select(:id, :name)    
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

  # mappings for the type of form
  JSON_IMPORT = 'json_import'
  RUN_TASK = 'run_task'
  ALLOWED_WORK_MAPPINGS = {
    markdown: ScanLzGuidesJob,
    lz_site: ScanLzSiteJob
  }
  # POST /data_imports
  def create
    if import_type_param == JSON_IMPORT
      Rails.logger.debug(" JSON IMPORT ")
      @library = Library.find(direct_import_params[:library])
      begin
        Rails.logger.info JSON.parse(direct_import_params[:json])
      rescue StandardError =>  e
        puts e
        return unprocessable_entity(notice: "Invalid JSON")
      end
      # do something with the json here
      return handle_json_import
    elsif import_type_param == RUN_TASK
      Rails.logger.debug(" RUN TASK IMPORT ")

      task = ALLOWED_WORK_MAPPINGS[task_params&.to_sym]

      if task.present?
        task.perform_later
        return redirect_to data_imports_path, notice: "Task enqueued"
      else
        return unprocessable_entity
      end

    else # we don't know what type of import you're talking about
      return unprocessable_entity
    end
  end
  
  def unprocessable_entity(notice: nil)
    @libraries = Library.all.select(:id, :name)

    flash[:notice] = notice if notice
    render :index, status: :unprocessable_entity
  end

  def handle_json_import
    json = direct_import_params[:json]
    if JsonImportJob.is_valid_json?(json)
      JsonImportJob.perform_later(json: json, library_id: @library.id)

      return redirect_to data_imports_path, notice: "Thanks for JSON"
    end
    unprocessable_entity(notice: "JSON not valid, or contains incorrect keys")
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
    def import_type_param
      params.fetch(:type, nil)
    end
    
    # Only allow a list of trusted parameters through.
    def task_params
      params.fetch(:task)
    end

    def direct_import_params
      params.slice(:library, :json, :authenticity_token)
    end
end
