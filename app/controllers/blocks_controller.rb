require 'tmpdir'
require 'pathname'

class BlocksController < ApplicationController
  before_action :set_block, only: [:show, :edit, :update, :destroy]
  before_filter :must_be_signed_in

  skip_before_filter :verify_authenticity_token, only: [:create, :destroy, :upload, :download]

  # GET /blocks/1ab2
  # GET /blocks/1ab2.json
  def show
    
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
  
  # POST /blocks/remove
  # POST /blocks/remove.json
  def remove
    # Bulk delete. 
    
  end

  # DELETE /blocks/1ab2
  # DELETE /blocks/1ab2.json
  def destroy
    @block.destroy
    respond_to do |format|
      format.html { redirect_to blocks_url }
      format.json { head :no_content }
    end
  end
end
