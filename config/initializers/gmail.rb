# Fix encoding problem
Net::IMAP::Address.class_eval do
  def name
    return Mail::Encodings.value_decode( self[:name] ) unless self[:name].nil?
  end
end

Gmail::Message.class_eval do
  def labels
    #didnt work
    @gmail.conn.uid_fetch(uid, "X-GM-LABELS")[0].attr["X-GM-LABELS"]
  end

  # Solve encoding problem, message class returns the right value
  def subject
    message.subject
  end

end

Gmail::Mailbox.class_eval do
  def search query, &block
    opts = { query: ['X-GM-RAW', query] }
    emails opts, &block
  end
end


Gmail::Client::Base.class_eval do
  I18N_BOX_LABELS = {
      sent: ['[Gmail]/Sent Mail', '[Gmail]/Enviados'],
      all:  ['[Gmail]/All Mail', '[Gmail]/Todos'],
      draft: [],
      trash: []
  }

  def get_right_box type
    box = (I18N_BOX_LABELS[type] & labels.all).first
    raise "No #{type} label found in this Gmail account" if box.nil?
    box
  end

  def all
    mailbox get_right_box(:all)
  end

  def sent
    mailbox get_right_box(:sent)
  end

  #Search using gmail syntax on all email
  def search(query, &block)
    mailbox(get_right_box :all).search(query, &block)
  end
end
