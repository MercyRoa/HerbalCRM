module MailProcessor
  class YaNoMasSobrepeso
    ADDRESS = ['system@yanomassobrepeso.com']

    def self.identify message, email
      if ADDRESS.include? message.from then
        puts '-- YaNoMasSobrepeso --'
        email.from.first.name = message.body.match(/Nombre: (.*)/)[1].strip
        message.from = message.body.match(/Email: (.*)/)[1].strip
      end
      return message, email
    end
  end
end