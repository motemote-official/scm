# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, "development"
set :output, {error: "log/cron_error_log.log", standard: "log/cron_log.log"}

#every 1.minutes do
#  puts "Whenever woking~!!"
#  File.open("log/test.log", 'a') { |file| file.write("test") }
#end

require "tzinfo"

def local(time)
  TZInfo::Timezone.get('Asia/Seoul').local_to_utc(Time.parse(time))
end

every 1.day, at: local("5:00 pm") do
  runner "Product.whenever_create"
end
