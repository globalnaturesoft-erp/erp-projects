module Erp
  module Projects
    module Backend
      class ProjectsController < Erp::Backend::BackendController
        before_action :set_project, only: [:show, :edit, :update, :destroy, :move_up, :move_down]

        # GET /projects
        def list
          @projects = Project.search(params).paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end

        # GET /projects/1
        def show
        end

        # GET /projects/new
        def new
          @project = Project.new

          if request.xhr?
            render '_form', layout: nil, locals: {project: @project}
          end
        end

        # GET /projects/1/edit
        def edit
        end

        # POST /projects
        def create
          @project = Project.new(project_params)
          @project.creator = current_user

          if @project.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @project.id,
                value: @project.name
              }
            else
              redirect_to erp_projects.edit_backend_project_path(@project), notice: t('.success')
            end
          else
            if request.xhr?
              render '_form', layout: nil, locals: {project: @project}
            else
              render :new
            end
          end
        end

        # PATCH/PUT /projects/1
        def update
          if @project.update(project_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @project.id,
                value: @project.name
              }
            else
              redirect_to erp_projects.edit_backend_project_path(@project), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /projects/1
        def destroy
          @project.destroy

          respond_to do |format|
            format.html { redirect_to erp_projects.backend_projects_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # dataselect /projects
        def dataselect
          respond_to do |format|
            format.json {
              render json: Project.dataselect(params[:keyword])
            }
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_project
            @project = Project.find(params[:id])
          end

          # Only allow a trusted parameter "white list" through.
          def project_params
            params.fetch(:project, {}).permit(:image, :name, :customer_id, :location, :area, :start_date, :completion_date, :description, :category_id,# :meta_keywords, :meta_description,
                                              :project_images_attributes => [ :id, :project_id, :name, :image_url, :_destroy ])
          end
      end
    end
  end
end