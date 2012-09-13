# encode: UTF-8
#require 'iconv'
def force_utf(s)
  #Iconv.conv('UTF-8//IGNORE', 'UTF-8', s + ' ')[0..-2]
end

class Message < ActiveRecord::Base
  belongs_to :lead
  validates_uniqueness_of :message_id

  def self.convert_from_gmail email
    self.new({
      message_id: email.message_id.to_s, #.tr('<>', '').tr('/', '-')
      subject:    Mail::Encodings.value_decode( email.subject ),
      from:       Array(email.from).map { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
      to:         Array(email.to).map   { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
      date:       (Time.parse(email.date).strftime('%Y-%m-%dT%H:%M:%S%z') rescue nil),
      #body:       (email.body.parts.first.body.to_s rescue email.body.to_s).gsub( /^From: .*@.*/m, '').strip.force_encoding('UTF-8'),
      #body:       Mail.new(email.body.to_s).body.decoded
      body:       ((email.multipart?)? email.text_part : email.body).decoded.force_encoding("ISO-8859-1").encode("UTF-8").strip,
      body_raw:   (email.multipart?)? email.html_part.body.decoded.force_encoding("ISO-8859-1").encode("UTF-8").strip : ''
    })
  end
end
