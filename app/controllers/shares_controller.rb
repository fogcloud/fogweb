class SharesController < ApplicationController
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

  # POST /shares/1a1a/get (json)
  def get_blocks
    name = params[:block]
    data = @share.block_data(name)
    
    if data
      send_data data, type: 'application/octet-stream'
    else
       respond_to do |format|
        logger.info @share.errors.inspect
        format.json do
          render json: { error: "Couldn't access block" }, status: :unprocessable_entity
        end
      end
    end
  end

  # POST /shares/1a1a/put/2b2b (json)
  def put_blocks
    name = params[:block]
    upload = params[:upload]

    bb = Block.new(@share, name)
    bb.save_upload(upload)

    if bb.errors.empty?
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        logger.info bb.errors.inspect
        format.json { render json: bb.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /shares/1a1a/remove (json)
  def remove_blocks
    blocks = params[:blocks]

    blocks.each do |name|
      bb = Block.new(@share, name)
      bb.remove!
    end
   
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def set_share
    @share = Share.find_by(user_id: current_user.id, name: params[:name])

    unless @share
      respond_to do |format|
        format.json do
          render json: { error: "No such share"}, status: :unprocessable_entity
        end
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def share_params
    params.require(:share).permit(:name, :root)
  end
end
