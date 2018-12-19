module Erp
  module Projects
    module Backend
      class ProjectImagesController < Erp::Backend::BackendController        
        def form_line
          @project_image = ProjectImage.new
          render partial: params[:partial], locals: { project_image: @project_image, uid: helpers.unique_id() }
        end
      end
    end
  end
end
