# Preview all emails at http://localhost:3000/rails/mailers
class WelcomeDripPreview < ActionMailer::Preview
  def welcome
    user = User.last

    WelcomeDripMailer.welcome(user)
  end
end
