require 'tmpdir'
require 'pathname'

class BlocksController < ApplicationController
  before_action :set_block, only: [:show, :edit, :update, :destroy]
  before_filter :must_be_signed_in

  skip_before_filter :verify_authenticity_token, only: [:create, :destroy]

  # GET /blocks
  # GET /blocks.json
  def index
    @blocks = current_user.blocks
  end

  # GET /blocks/1
  # GET /blocks/1.json
  def show
  end

  # GET /blocks/new
  def new
    @block = Block.new
  end

  # GET /blocks/1/edit
  def edit
  end

  # POST /blocks
  # POST /blocks.json
  def create
    @block = Block.new(block_params)
    @block.user_id = current_user.id

    dup = Block.find_by_name(@block.name)
    unless dup.nil?
      if @block.user_id != dup.user_id
        raise Exception.new("Same block name for two users. Don't share keys.")
      end

      @block = dup
      @block.updated_at = Time.now
    end

    respond_to do |format|
      if @block.save
        format.html { redirect_to @block, notice: 'Block was successfully created.' }
        format.json { render action: 'show', status: :created, location: @block }
      else
        @block.cleanup!

        format.html { render action: 'new' }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /blocks/upload_form
  def upload_form
  end

  # POST /blocks/upload
  # POST /blocks/upload.json
  def upload
    # Bulk upload. Ship a tarball of blocks.
    
    @tar = params.require(:tarball)

    blocks = []

    Dir.mktmpdir do |tmp|
      system(%Q{(cd "#{tmp}" && tar xf "#{@tar.path}")})
      Dir.foreach(tmp) do |file|
        unless file.size == 64 
          puts "'#{file}' wrong length"
          next
        end

        blocks << file

        if Block.find_by_name(file)
          puts "Got that one: #{file}"
        else
          File.open("#{tmp}/#{file}") do |upload|
            bb = Block.new
            bb.user_id = current_user.id
            bb.name   = Pathname.new(file).basename.to_s
            bb.upload = upload
            bb.save!
          end
        end
      end
    end

    render json: {'uploaded' => blocks}, status: 200
  end

  # GET /blocks/download_form
  def download_form
  end

  # POST /blocks/download
  # POST /blocks/download.json
  def download
    # Bulk download. Ship a tarball of blocks.
   
    @blocks = params.require(:blocks).split(/\s+/)
   
    if @blocks.size > 2560
      render json: {"error" => "Too many blocks"}, status: 413
      return
    end

    Dir.mktmpdir do |tmp|
      system(%Q{mkdir "#{tmp}/blocks"})

      @blocks.each do |bname|
        block = Block.find_by_name(bname) or next
        system(%Q{cp "#{block.file}" "#{tmp}/blocks/#{block.name}"})
      end
      
      system(%Q{cd "#{tmp}/blocks" && tar cf "#{tmp}/blocks.tar" *}) 

      send_data File.read("#{tmp}/blocks.tar"), type: 'application/x-tar'
    end
  end

  # POST /blocks/remove
  # POST /blocks/remove.json
  def remove
    # Bulk delete. 
    
  end

  # PATCH/PUT /blocks/1
  # PATCH/PUT /blocks/1.json
  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to @block, notice: 'Block was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blocks/1
  # DELETE /blocks/1.json
  def destroy
    @block.destroy
    respond_to do |format|
      format.html { redirect_to blocks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_block
      @block = Block.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def block_params
      params.require(:block).permit(:name, :upload)
    end
end
