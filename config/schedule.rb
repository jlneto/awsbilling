# Learn more: http://github.com/javan/whenever

every 1.day, at: '6am' do
  runner 'Account.deliver_daily_reports'
end