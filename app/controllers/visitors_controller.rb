class VisitorsController < ApplicationController

  def index
    @account = current_user.account
  end

end
