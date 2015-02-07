require_dependency "digest_rails/application_controller"

#module DigestRails
  module Ui
  class DigestsController < ApplicationController
    layout 'digest-rails/application'
    # GET /digests
    # GET /digests.json
    def index
      @digests = DigestRails::Digest.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @digests }
      end
    end
  
    # GET /digests/1
    # GET /digests/1.json
    def show
      @digest = Digest.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @digest }
      end
    end
  
    # GET /digests/new
    # GET /digests/new.json
    def new
      @digest = Digest.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @digest }
      end
    end
  
    # GET /digests/1/edit
    def edit
      @digest = Digest.find(params[:id])
    end
  
    # POST /digests
    # POST /digests.json
    def create
      @digest = Digest.new(params[:digest])
  
      respond_to do |format|
        if @digest.save
          format.html { redirect_to @digest, notice: 'Digest was successfully created.' }
          format.json { render json: @digest, status: :created, location: @digest }
        else
          format.html { render action: "new" }
          format.json { render json: @digest.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /digests/1
    # PUT /digests/1.json
    def update
      @digest = Digest.find(params[:id])
  
      respond_to do |format|
        if @digest.update_attributes(params[:digest])
          format.html { redirect_to @digest, notice: 'Digest was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @digest.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /digests/1
    # DELETE /digests/1.json
    def destroy
      @digest = Digest.find(params[:id])
      @digest.destroy
  
      respond_to do |format|
        format.html { redirect_to digests_url }
        format.json { head :no_content }
      end
    end
  end
  end

