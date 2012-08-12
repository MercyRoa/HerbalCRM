class MailSequencesController < ApplicationController
  # GET /mail_sequences
  # GET /mail_sequences.json
  def index
    @mail_sequences = MailSequence.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mail_sequences }
    end
  end

  # GET /mail_sequences/1
  # GET /mail_sequences/1.json
  def show
    @mail_sequence = MailSequence.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mail_sequence }
    end
  end

  # GET /mail_sequences/new
  # GET /mail_sequences/new.json
  def new
    @mail_sequence = MailSequence.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mail_sequence }
    end
  end

  # GET /mail_sequences/1/edit
  def edit
    @mail_sequence = MailSequence.find(params[:id])
  end

  # POST /mail_sequences
  # POST /mail_sequences.json
  def create
    @mail_sequence = MailSequence.new(params[:mail_sequence])

    respond_to do |format|
      if @mail_sequence.save
        format.html { redirect_to @mail_sequence, notice: 'Mail sequence was successfully created.' }
        format.json { render json: @mail_sequence, status: :created, location: @mail_sequence }
      else
        format.html { render action: "new" }
        format.json { render json: @mail_sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mail_sequences/1
  # PUT /mail_sequences/1.json
  def update
    @mail_sequence = MailSequence.find(params[:id])

    respond_to do |format|
      if @mail_sequence.update_attributes(params[:mail_sequence])
        format.html { redirect_to @mail_sequence, notice: 'Mail sequence was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @mail_sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_sequences/1
  # DELETE /mail_sequences/1.json
  def destroy
    @mail_sequence = MailSequence.find(params[:id])
    @mail_sequence.destroy

    respond_to do |format|
      format.html { redirect_to mail_sequences_url }
      format.json { head :ok }
    end
  end
end
