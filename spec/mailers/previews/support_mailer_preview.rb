# Preview all emails at http://localhost:3000/rails/mailers/support_mailer
class SupportMailerPreview < ActionMailer::Preview
  def lead
    u = User.first
    lead = u.leads.build(note: "hi this is my testing note", preferred_contact: "email")
    SupportMailer.lead(lead)
  end
end
