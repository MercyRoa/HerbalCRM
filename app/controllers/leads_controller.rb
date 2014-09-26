class LeadsController < ApplicationController
  # GET /leads
  # GET /leads.json
  def index
    #@leads = Lead.all
    #raise Filters::LeadFilter.inspect
    if params.empty? then
      params[:wf_order] = :created_at 
      params[:wf_per_page] = '100'
    end
    @leads= Lead.filter(:params => params, :filter => Filters::LeadFilter)
    @campaigns = Campaign.all
    @new_message = ScheduledMessage.new


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leads }
    end
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
    @lead = Lead.find(params[:id])

    @lead.set_access_by

    # This was suggested on a forum with @lead.messages.build
    # Yaraher suggested to use build, but copy @lead.messages before
    #@new_message = @lead.scheduled_messages.build #ScheduledMessage.new(lead_id: @lead.id,
    @new_message = ScheduledMessage.new(lead_id: @lead.id, account_id: @lead.account_id)
    @new_note = Note.new(lead_id: @lead.id)

    @history = (@lead.messages + @lead.notes).sort_by(&:created_at).reverse

    #@text_models = TextModel.all
    @text_models = @lead.campaign.all_text_models

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lead }
      format.js
    end
  end

  # GET /leads/new
  # GET /leads/new.json
  def new
    @lead = Lead.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lead }
    end
  end

  # GET /leads/1/edit
  def edit
    @lead = Lead.find(params[:id])
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(params[:lead])

    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, notice: 'Lead was successfully created.' }
        format.json { render json: @lead, status: :created, location: @lead }
      else
        format.html { render action: "new" }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leads/1
  # PUT /leads/1.json
  def update
    @lead = Lead.find(params[:id])

    respond_to do |format|
      if @lead.update_attributes(params[:lead])
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
      format.js
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead = Lead.find(params[:id])
    @lead.destroy

    respond_to do |format|
      format.html { redirect_to leads_url }
      format.json { head :ok }
    end
  end
end
