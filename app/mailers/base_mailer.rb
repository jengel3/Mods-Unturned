require 'digest/sha2'
class BaseMailer < ActionMailer::Base
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@mods-unturned.com"
  add_template_helper(ApplicationHelper)
  default from: "no-reply@mods-unturned.com"
  @@no_relpy = "no-reply@mods-unturned.com"
end
