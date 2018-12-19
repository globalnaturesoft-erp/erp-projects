class CreateErpProjectsProjectImages < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_projects_project_images do |t|
      t.string :name
      t.string :image_url
      t.references :project, index: true, references: :erp_projects_projects

      t.timestamps
    end
  end
end
