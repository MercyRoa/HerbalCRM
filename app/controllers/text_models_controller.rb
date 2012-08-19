class TextModelsController < ApplicationController
  # GET /text_models
  # GET /text_models.json
  def index
    @text_models = TextModel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @text_models }
    end
  end

  # GET /text_models/1
  # GET /text_models/1.json
  def show
    @text_model = TextModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @text_model }
    end
  end

  # GET /text_models/new
  # GET /text_models/new.json
  def new
    @text_model = TextModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @text_model }
    end
  end

  # GET /text_models/1/edit
  def edit
    @text_model = TextModel.find(params[:id])
  end

  # POST /text_models
  # POST /text_models.json
  def create
    @text_model = TextModel.new(params[:text_model])

    respond_to do |format|
      if @text_model.save
        format.html { redirect_to @text_model, notice: 'Text model was successfully created.' }
        format.json { render json: @text_model, status: :created, location: @text_model }
      else
        format.html { render action: "new" }
        format.json { render json: @text_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /text_models/1
  # PUT /text_models/1.json
  def update
    @text_model = TextModel.find(params[:id])

    respond_to do |format|
      if @text_model.update_attributes(params[:text_model])
        format.html { redirect_to @text_model, notice: 'Text model was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @text_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /text_models/1
  # DELETE /text_models/1.json
  def destroy
    @text_model = TextModel.find(params[:id])
    @text_model.destroy

    respond_to do |format|
      format.html { redirect_to text_models_url }
      format.json { head :ok }
    end
  end
end
