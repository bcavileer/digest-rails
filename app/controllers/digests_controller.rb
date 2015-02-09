require_dependency "digest_rails/application_controller"

  class DigestsController < ApplicationController
    layout 'digest-rails/application'

    def digest_keys
      DigestRails::Digest.select('key').uniq.map{|r| r.key}
    end

    def raw_digest(key)
      DigestRails::Digest.where(:key => key).order("created_at").last
    end

    def url_subdomain(a_raw_digest)
      a_raw_digest.url_subdomain
    end

    def server_name
      r = request.env["SERVER_NAME"]
      rsplit = r.split('.')
      r = rsplit[1..-1].join('.') if rsplit.length > 2
      return r
    end

    def server_port
      request.env["SERVER_PORT"]
    end

    def url_path(a_raw_digest)
      rsplit = a_raw_digest.path_repl_command.split('.')
      rsplit[-1].split('_')[0..-2].join('_')
    end

    def digest_url(a_raw_digest)
      "http://#{a_raw_digest.url_subdomain}.#{server_name}:#{server_port}/#{url_path(a_raw_digest)}"
    end

    def link_urls(a_raw_digest)
      a_raw_digest.instance_variable_set( :@url, digest_url(a_raw_digest) )
    end

    def digests
      @digests =  digest_keys.map do |key|
        r = raw_digest(key)
        link_urls(r)
        r
      end
    end

    # GET /digests
    # GET /digests.json
    def index
      @digests = digests
  
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
