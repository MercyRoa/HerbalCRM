class LeadDetailsController < ApplicationController
  # GET /lead_details
  # GET /lead_details.json
  def index
    @lead_details = LeadDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lead_details }
    end
  end

  # GET /lead_details/1
  # GET /lead_details/1.json
  def show
    @lead_detail = LeadDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lead_detail }
    end
  end

  # GET /lead_details/new
  # GET /lead_details/new.json
  def new
    @lead_detail = LeadDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lead_detail }
    end
  end

  # GET /lead_details/1/edit
  def edit
    @lead_detail = LeadDetail.find(params[:id])
  end

  # POST /lead_details
  # POST /lead_details.json
  def create
    @lead_detail = LeadDetail.new(params[:lead_detail])

    respond_to do |format|
      if @lead_detail.save
        format.html { redirect_to @lead_detail, notice: 'Lead detail was successfully created.' }
        format.json { render json: @lead_detail, status: :created, location: @lead_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @lead_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lead_details/1
  # PUT /lead_details/1.json
  def update
    @lead_detail = LeadDetail.find(params[:id])

    respond_to do |format|
      if @lead_detail.update_attributes(params[:lead_detail])
        format.html { redirect_to @lead_detail, notice: 'Lead detail was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @lead_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lead_details/1
  # DELETE /lead_details/1.json
  def destroy
    @lead_detail = LeadDetail.find(params[:id])
    @lead_detail.destroy

    respond_to do |format|
      format.html { redirect_to lead_details_url }
      format.json { head :ok }
    end
  end
end
