module Erp::Projects
  class ProjectImage < ApplicationRecord
    belongs_to :project, class_name: 'Erp::Projects::Project'
    mount_uploader :image_url, Erp::Projects::ProjectImageUploader
    
    default_scope { order(id: :desc) }
  end
end
