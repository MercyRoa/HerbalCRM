module MailProcessor
  class ContactMe
    ADDRESS = ['notifications@unbounce.com']

    def self.identify message, email
      if ADDRESS.include? message.from then
        puts '-- Unbounce ---'
        email.from.first.name = message.body.match(/nombre: (.*)/)[1].strip
        message.from = message.body.match(/email: (.*)"/)[1].strip
        message.subject = "Hola #{email.from.first.name}! "
      end
      return message, email
    end
  end
end