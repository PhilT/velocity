class ReleaseMailer < ActionMailer::Base
  def release_notification(recipients, release)
    recipients    recipients.map(&:email_address_with_name)
    from          "todo@puresolo.com"
    subject       "Release #{release.finished_at.to_s}"
    body          :release => release
    content_type  "text/html"
  end
end

