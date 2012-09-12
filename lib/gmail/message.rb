module Gmail
  class Message
    def labels
      @gmail.conn.uid_fetch(uid, "X-GM-LABELS")[0].attr["X-GM-LABELS"]
    end

    def manolo
      puts "EXITO"
    end
  end
end