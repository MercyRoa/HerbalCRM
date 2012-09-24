class SetDefaultsToLead < ActiveRecord::Migration
  def up
    change_column_default :leads, :step, 1
    change_column_default :leads, :automatic, true
    change_column_default :leads, :messages_received_count, 0
    change_column_default :leads, :messages_sent_count, 0
    change_column_default :leads, :bounce, 0
    change_column_default :leads, :status, 'new'

    Lead.all.each do |l|
      l.update_attributes({
        step: 1,
        automatic: true,
        messages_received_count: 0,
        messages_sent_count: 0,
        bounce: 0,
        status: 'new'
      })
    end
  end

  def down
    change_column_default :leads, :step, nil
    change_column_default :leads, :automatic, nil
    change_column_default :leads, :messages_received_count, nil
    change_column_default :leads, :messages_sent_count, nil
    change_column_default :leads, :bounce, nil
    change_column_default :leads, :status, nil
  end
end
