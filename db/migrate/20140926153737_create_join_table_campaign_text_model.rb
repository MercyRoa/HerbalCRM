class CreateJoinTableCampaignTextModel < ActiveRecord::Migration
    def self.up
        create_table :campaigns_text_models, :id => false do |t|
            t.integer :campaign_id
            t.integer :text_model_id
        end

        add_index :campaigns_text_models, [:campaign_id, :text_model_id]
    end

    def self.down
        drop_table :campaigns_text_models
    end
end
