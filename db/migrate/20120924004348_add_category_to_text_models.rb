class AddCategoryToTextModels < ActiveRecord::Migration
  def change
    add_column :text_models, :category, :string
  end
end
