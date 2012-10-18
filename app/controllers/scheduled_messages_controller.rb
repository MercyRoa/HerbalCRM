class ScheduledMessagesController < ApplicationController
  def send_all
    ScheduledMessage.send_all
    raise "OK"
  end

  def create
    @scheduled_message = ScheduledMessage.new(params[:scheduled_message])
    @scheduled_message = Time.now if @scheduled_message.nil?

    respond_to do |format|
      if @scheduled_message.save
        # If we manually create a scheduled message we change automated to false
        @scheduled_message.lead.update_attribute :automated, false

        format.html { redirect_to @scheduled_message.lead, notice: 'Message was successfully scheduled.' }
        format.json { render json: @scheduled_message, status: :created, location: @scheduled_message }
      else
        format.html { render action: "new" }
        format.json { render json: @scheduled_message.errors, status: :unprocessable_entity }
      end
    end
  end

end
