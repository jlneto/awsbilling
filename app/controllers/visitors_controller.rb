class VisitorsController < ApplicationController

  def index
    if current_user.account
      @account = current_user.account
    else
      redirect_to new_account_path
    end
  end

end
