class AddAutomaticToMailSequences < ActiveRecord::Migration
  def change
    add_column :mail_sequences, :automatic, :boolean
  end
end
