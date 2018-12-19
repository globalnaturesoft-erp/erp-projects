class CreateErpProjectsProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_projects_projects do |t|
      t.string :image
      t.string :name
      t.string :location
      t.string :area # dien tich
      t.datetime :start_date
      t.datetime :completion_date
      t.text :description
      t.string :status
      t.references :category, index: true, references: :erp_projects_categories
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
