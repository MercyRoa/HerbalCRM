class AddNoteToLeadDetails < ActiveRecord::Migration
  def change
    add_column :lead_details, :note, :string
  end
end
