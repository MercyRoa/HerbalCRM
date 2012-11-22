module MailProcessor
  class ContactMe
    ADDRESS = ['no-reply@contactme.com']

    def self.identify message, email
      if ADDRESS.include? message.from then
        puts '-- ContactMe ---'
        email.from.first.name = message.body.match(/Nombre: (.*)/)[1].strip
        message.from = message.body.match(/Email: (.*)/)[1].strip
        message.subject = "Hola #{email.from.first.name}"
        message.body = message.body.match(/(-{10,})(.*?)\1/m)[1].strip
      end
      return message, email
    end
  end
end

