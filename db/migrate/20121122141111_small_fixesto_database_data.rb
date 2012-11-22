class SmallFixestoDatabaseData < ActiveRecord::Migration
  def up
    Lead.all.each do |l|
      p = { email: l.email.downcase }
      unless l.first_name.nil?
        name = l.first_name.titleize.split(' ', 2)
        p[:first_name] = name.first
        p[:last_name] = name.last if (name.size == 2)
      end
      l.update_attributes p
    end
  end

  def down
  end
end
