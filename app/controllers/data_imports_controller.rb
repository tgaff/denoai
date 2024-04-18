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
    puts "---------------------------------"
    # puts import_type_param
    puts params.to_unsafe_hash

    # doing something weird - successful paths should throw done or 
    # we'll render unprocessable_entity
    catch(:done) do
      if import_type_param == JSON_IMPORT
        @library = Library.find(direct_import_params[:library])
        begin
          Rails.logger.info JSON.parse(direct_import_params[:json])
        rescue StandardError =>  e
          puts e
          render :index, status: :unprocessable_entity
        end
        # do something with the json here
        redirect_to data_imports_path, notice: "Thanks for JSON"

        throw(:done)
      elsif import_type_param == RUN_TASK
        task = ALLOWED_WORK_MAPPINGS[task_params&.to_sym]

        if task.present?
          # task.perform_later
          redirect_to data_imports_path, notice: "Task enqueued"
        else
          render :index, status: :unprocessable_entity
        end
        throw(:done)
      end

      # fallback if neither option gets a "done"
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
