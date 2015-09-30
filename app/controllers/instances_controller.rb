class InstancesController < ApplicationController
  before_action :set_instance, only: [:show, :edit, :update, :destroy, :start, :stop]

  # GET /instances
  # GET /instances.json
  def index
    @instances = current_account.instances.order(:name).all
  end

  # GET /instances/1
  # GET /instances/1.json
  def show
  end

  def load_from_aws
    current_account.load_from_aws
    redirect_to action: :index
  end

  def start
    @instance.start
    redirect_to @instance
  end

  def stop
    @instance.stop
    redirect_to @instance
  end

  # GET /instances/new
  def new
    @instance = Instance.new
  end

  # GET /instances/1/edit
  def edit
  end

  # POST /instances
  # POST /instances.json
  def create
    @instance = Instance.new(instance_params)

    respond_to do |format|
      if @instance.save
        format.html { redirect_to @instance, notice: 'Instance was successfully created.' }
        format.json { render :show, status: :created, location: @instance }
      else
        format.html { render :new }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instances/1
  # PATCH/PUT /instances/1.json
  def update
    respond_to do |format|
      if @instance.update(instance_params)
        format.html { redirect_to @instance, notice: 'Instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @instance }
      else
        format.html { render :edit }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instances/1
  # DELETE /instances/1.json
  def destroy
    @instance.destroy
    respond_to do |format|
      format.html { redirect_to instances_url, notice: 'Instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instance
      @instance = Instance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instance_params
      params.require(:instance).permit(:account_id, :name, :description, :instance_id, :instance_type, :availability_zone, :dns_address, :current_address)
    end
end
