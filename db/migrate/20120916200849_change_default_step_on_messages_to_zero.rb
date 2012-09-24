class ChangeDefaultStepOnMessagesToZero < ActiveRecord::Migration
  def up
    change_column_default :leads, :step, 0
  end

  def down
    change_column_default :leads, :step, 1
  end
end
