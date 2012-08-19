class CreateTextModels < ActiveRecord::Migration
  def change
    create_table :text_models do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
