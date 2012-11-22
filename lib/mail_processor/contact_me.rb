module MailProcessor
  class ContactMe
    ADDRESS = ['no-reply@contactme.com']

    def self.identify message, email
      if ADDRESS.include? message.from then
        puts '-- ContactMe ---'
        email.from.first.name = message.body.match(/Nombre: (.*)/)[1]
        message.from = message.body.match(/Email: (.*)/)[1]
        message.subject = "Hola #{email.from.first.name}"
      end
      return message, email
    end
  end
end