class CreateErpProjectsCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_projects_categories do |t|
      t.string :name
      t.text :description
      t.integer :parent_id
      t.string :status
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
