class Message < ActiveRecord::Base
  belongs_to :lead
  validates_uniqueness_of :message_id

  def self.convert_from_gmail email
    self.new({
      message_id: email.message_id.to_s, #.tr('<>', '').tr('/', '-')
      subject:    email.subject.to_s,
      from:       Array(email.from).map { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
      to:         Array(email.to).map   { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
      date:       (Time.parse(email.date).strftime('%Y-%m-%dT%H:%M:%S%z') rescue nil),
      body:       (email.body.parts.first.body.to_s rescue email.body.to_s).gsub( /^From: .*@.*/m, '').strip,
      body_raw:   email.body.to_s
    })
  end
end
