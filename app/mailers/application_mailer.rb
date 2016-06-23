class ApplicationMailer < ActionMailer::Base
  default from: "account-activation@leaguespec.com"
  layout 'mailer'
end
