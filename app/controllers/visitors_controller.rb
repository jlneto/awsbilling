class VisitorsController < ApplicationController

  def index
    if current_user.account
      @account = current_user.account
      res = @account.ec2_instances
      @instances = res[:on_demand].to_json
      @reserved = res[:reserved].to_json
    else
      redirect_to new_account_path
    end

  end

end
