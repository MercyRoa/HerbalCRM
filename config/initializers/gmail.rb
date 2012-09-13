Gmail::Message.class_eval do
  def labels
    #didnt work
    @gmail.conn.uid_fetch(uid, "X-GM-LABELS")[0].attr["X-GM-LABELS"]
  end

  def testing
    puts "ok!"
  end
end

a = Account.first