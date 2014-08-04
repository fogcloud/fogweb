require 'block_archive'

class SharesController < ApplicationController
  include ActionController::Live

  before_filter :must_be_signed_in

  before_filter :set_share, except: [:index, :create]
  before_filter :force_json_response

  # GET /shares (json)
  def index
    @shares = current_user.shares
  end

  # POST /shares
  # POST /shares.json
  def create
    @share = Share.new(share_params)
    @share.user_id = current_user.id 

    respond_to do |format|
      if @share.save
        format.json { render action: 'show', status: :created, location: @share }
      else
        logger.info @share.errors.inspect
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shares/1
  # PATCH/PUT /shares/1.json
  def update
    respond_to do |format|
      if @share.update(share_params)
        format.json { head :no_content }
      else
        logger.info @share.errors.inspect
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shares/1
  # DELETE /shares/1.json
  def destroy
    if @share.destroy
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        logger.info @share.errors.inspect
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /shares/1a1a (json)
  def show
    @blocks = @share.blocks
  end

  # POST /shares/1a1a/check (json)
  def check_blocks

  end

  # POST /shares/1a1a/get (binary)
  def get_blocks
    unless request.content_type =~ /octet/i
      raise StandardError.new("Expected binary body")
    end
 
    response.headers['Content-Type'] = 'application/octet-stream'

    ba = BlockArchive.new(response.stream, @share.block_size)

    request.body.each do |name|
      name.chomp!
      bb = Block.new(@share, name)
      ba.add(name, bb.data)
    end
      
    ba.close
  end

  # POST /shares/1a1a/put/2b2b (binary)
  def put_blocks
    unless request.content_type =~ /octet/i
      raise StandardError.new("Expected binary body")
    end

    ba = BlockArchive.new(request.body, @share.block_size)
    count = 0

    begin
      ba.each do |name, data|
        bb = Block.new(@share, name)
        bb.save_data(data)

        if bb.errors.nil? || bb.errors.empty?
          count = count + 1
        else
          raise Exception.new(bb.errors)
        end
      end
    rescue StandardError => ee
      logger.info ee.backtrace
      logger.info ee.inspect
      respond_to do |format|
        format.json { render json: {error: ee.inspect}, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      format.json do
        logger.info "Saved #{count} blocks"
        if count == 0
          render json: {error: "Updated no blocks"}, status: 400
        else
          render json: {count: count}, status: 200
        end
      end
    end
  end

  # POST /shares/1a1a/remove (json)
  def remove_blocks
    request.body.each_line do |name|
      name.chomp!
      bb = Block.new(@share, name)
      bb.remove!
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # POST /shares/1a1a/casr (json)
  def swap_root
    begin
      prev = params[:prev]
      root = params[:root]

      bb = Block.new(@share, root)
      unless File.exist?(bb.path)
        raise StandardError.new("No such block")
      end

      Share.transaction do
        ss = Share.find(@share.id)
        if ss.root == prev
          ss.root = root
          ss.save!
        else
          logger.info "Curr root: [#{ss.root}]"
          logger.info "Prev root: [#{prev}]"
          raise StandardError.new("Compare Failed")
        end
      end
      
      respond_to do |format|
        format.json { head :no_content }
      end
    rescue StandardError => ee
      respond_to do |format|
        logger.info ee
        format.json { render json: {error: ee}, status: 409 }
      end
    end
  end

  private

  def set_share
    @share = Share.find_by(user_id: current_user.id, name: params[:name])

    unless @share
      respond_to do |format|
        format.json do
          render json: { error: "No such share"}, status: 404
        end
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def share_params
    params.require(:share).permit(:name, :root, :secrets, :block_size)
  end
end
