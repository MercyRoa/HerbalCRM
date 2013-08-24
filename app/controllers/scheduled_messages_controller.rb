class ScheduledMessagesController < ApplicationController
  def send_all
    ScheduledMessage.send_all
    raise "OK"
  end

  def index
    @scheduled_messages = ScheduledMessage.where(:sent => false)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scheduled_messages }
    end
  end

  def edit
    @scheduled_message = ScheduledMessage.find(params[:id])
    if @scheduled_message.sent?
      redirect_to scheduled_messages_url, notice: 'This message was already sent and cant be edited'
    end
  end

  def update
    @scheduled_message = ScheduledMessage.find(params[:id])

    respond_to do |format|
      if @scheduled_message.update_attributes(params[:scheduled_message])
        format.html { redirect_to lead_url(@scheduled_message.lead), notice: 'Scheduled Message was successfully
updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @scheduled_message.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @scheduled_message = ScheduledMessage.find(params[:id])
    lead = @scheduled_message.lead
    @scheduled_message.destroy

    respond_to do |format|
      format.html { redirect_to lead_url(lead) }
      format.json { head :ok }
      format.js
    end
  end

  def create
    @scheduled_message = ScheduledMessage.new(params[:scheduled_message])
    @scheduled_message = Time.now if @scheduled_message.nil?
    respond_to do |format|
      if @scheduled_message.save
        # If we manually create a scheduled message we change automated to false
        @scheduled_message.lead.update_attributes automatic: false

        format.html { redirect_to @scheduled_message.lead, notice: 'Message was successfully scheduled.' }
        format.json { render json: @scheduled_message, status: :created, location: @scheduled_message }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @scheduled_message.errors, status: :unprocessable_entity }
      end
    end
  end

end
