imap = Net::IMAP.new(@config['server'],@config['port'],true)
imap.login(@config['username'], @config['password'])
imap.select('INBOX')
imap.search(["NOT", "DELETED"]).each do |message_id|
  MailFetcher.receive(imap.fetch(message_id, "RFC822")[0].attr["RFC822"])
  imap.store(message_id, "+FLAGS", [:Deleted])
end
imap.logout()
imap.disconnect() 