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

every 1.day, at: '5:30 pm', tz: 'Seoul' do
  mechanize = Mechanize.new
  login = mechanize.get('https://www.901giji.com/scm/index.php/member/login')

  #look for the wanted form
  form = login.form_with action: "https://www.901giji.com/scm/index.php/member/login_chk"
  form.field_with(name: "id").value = ENV['SCM_ID']
  form.field_with(name: "password").value = ENV['SCM_PASSWORD']
  form.submit

  scm = mechanize.get("https://www.901giji.com/scm/index.php/product/search")

  @data = {}
  count = scm.parser.css("table.table tbody tr").count

  for i in 1..count do
    @data[scm.parser.css("table.table tbody tr[#{i}] td[2]").text.to_sym] = scm.parser.css("table.table tbody tr[#{i}] td[8]").text.tr(',','').to_i
  end

  Product.all.each do |p|
    count = @data[:"#{p.code}"]

    if Count.where(product_id: p.id).where(date: (Date.today.in_time_zone("Seoul") - 1).to_s).take.present?
      if count > Count.where(product_id: p.id).where(date: (Date.today.in_time_zone("Seoul") - 1).to_s).take.count
        Count.create(count: count, product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: true)
      else
        Count.create(count: count, product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: false)
      end
    else
      Count.create(count: count, product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: true)
    end
  end
end
