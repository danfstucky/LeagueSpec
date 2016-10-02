class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "League Spec account activation"
    mail from: "account-activation@leaguespec.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "League Spec password reset"
    mail from: "password-reset@leaguespec.com"
  end
  
  def friendship_request(friendship)
    @user = friendship.user
    @friend = friendship.friend
    @friendship = friendship
    mail to: friendship.friend.email, subject: "League Spec Friend Request"
    mail from: "friendship-request@leaguespec.com"
  end

  def invitation_request(user, email, name)
    @name = name
    @registered_summoner = user
    mail to: email, subject: "Invitation to Join LeagueSpec: A LoL Enthusiast Community!"
    mail from: "new-user-invitation@leaguespec.com"
  end
end
