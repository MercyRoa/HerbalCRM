class CreateMailSequences < ActiveRecord::Migration
  def change
    create_table :mail_sequences do |t|
      t.integer :campaign_id
      t.integer :step
      t.string :subject
      t.text :body_text
      t.text :body_html
      t.string :description
      t.integer :send_after

      t.timestamps
    end
  end
end
