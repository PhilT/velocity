class ReleaseMailer < ActionMailer::Base
  helper :tasks

  def release_notification(recipients, release)
    @release = release
    mail(:from => 'todo@example.com',
         :to => recipients.map(&:email_address_with_name),
         :subject => "Release #{release.created_at.to_s}",
         :content_type => "text/html"
        )
  end
end

