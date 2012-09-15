puts "todo completado"

class Arnold
  attr_accessor :nombre, :apellido
  def email arr, &block
    #3.times { yield }
    block.call arr
  end
  def search &block
    arr = %w{hola juanito lindo}
    email arr, &block
  end
end
a = Arnold.new
a.search do |a|
  puts a
end

exit
@config = {
	'server' => 'imag.google.com',
	'port' => 995,
	'username' => 'mercedes@yanomassobrepeso.com',
	'password' => 'merce1957'
}
imap = Net::IMAP.new(@config['server'],@config['port'],true)
imap.login(@config['username'], @config['password'])
imap.select('INBOX')
imap.search(["NOT", "DELETED"]).each do |message_id|
  MailFetcher.receive(imap.fetch(message_id, "RFC822")[0].attr["RFC822"])
  imap.store(message_id, "+FLAGS", [:Deleted])
end
imap.logout()
imap.disconnect() 