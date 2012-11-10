class MailSequence < ActiveRecord::Base
  belongs_to :campaign
  validates_presence_of :step, :subject
  before_save :set_plain_from_html

  def set_plain_from_html
    self.body_text = html_to_text(body_html)
  end
end
