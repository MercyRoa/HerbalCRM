module I18n::MissingTranslation::Base

  def html_message_with_en_fix
    (locale == :en) ? key : html_message_without_en_fix
  end
  alias_method_chain :html_message, :en_fix

  def message_with_en_fix
    (locale == :en) ? key : message_without_en_fix
  end
  alias_method_chain :message, :en_fix

end
