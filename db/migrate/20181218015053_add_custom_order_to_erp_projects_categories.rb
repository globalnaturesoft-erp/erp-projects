class AddCustomOrderToErpProjectsCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_projects_categories, :custom_order, :integer
  end
end
