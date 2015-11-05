class VisitorsController < ApplicationController

  def index
    if current_user.account
      @account = current_user.account
      reference_date = Date.parse(params[:ref_date], '%Y-%m-%d') if params[:ref_date].present?
      reference_date = Date.today if reference_date.blank?
      @account.reference_date = reference_date
      res = @account.ec2_instances
      @instances = res[:on_demand].to_json
      @reserved = res[:reserved].to_json
    else
      redirect_to new_account_path
    end

  end

end
