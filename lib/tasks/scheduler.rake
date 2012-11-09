desc "This task is called by the Heroku scheduler add-on"
task :fetch_all_emails => :environment do
  puts "Importing emails..."
  Campaign.fetch_all
  puts "done."
end

task :generate_messages_for_leads => :environment do
  puts "Generating messages for leads"
  Lead.generate_automated_messages_for_all
  puts "done."
end

task :send_scheduled_emails => :environment do
  puts "Sending emails"
  ScheduledMessage.send_all
  puts "done."
end

task :all => :environment do
  Rake::Task["fetch_all_emails"].execute
  Rake::Task["generate_messages_for_leads"].execute
  Rake::Task["send_scheduled_emails"].execute
end