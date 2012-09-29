module LeadsHelper
  # Colors for use with bootstrap's labels
  STATUS_COLORS = {
      new: 'info',
      attention_needed: 'warning',
      waiting_reply: 'success',
      posponed: '', #default
      discarted: 'inverse'
  }
  def status_label (lead)
    "<span class='label label-#{STATUS_COLORS[lead.status.to_sym]}'>#{lead.status.humanize}</span>".html_safe
  end

  def time_ago time
    return t('Never') if time.nil?
    time_ago_in_words time
  end
end
