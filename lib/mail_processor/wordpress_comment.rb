#encoding: UTF-8

module MailProcessor
  class WordpressComment
    ADDRESS = ['wordpress@experienciaherbalife.com']

    def self.identify message, email
      if ADDRESS.include? message.from then
        puts '-- Wordpress ---'
        
        #ignore pingback
        unless message.body.include?("Un nuevo pingback") then
          #Change campaign?

          #message.body = message.body.match(/(-{10,})(.*?)\1/m)[2].gsub!(/^\s+/, ' ') + " --CM"
          email.from.first.name = message.body.match(/Autor : ([\w ]*) \(/)[1].strip
          message.from = message.body.match(/Correo electrónico : (.*)/)[1].strip
          message.subject = "Hola #{email.from.first.name}"
        end

      end
      return message, email
    end
  end
end