class TimePeriodsController < ApplicationController
  def query
    @time_periods = TimePeriod.all

    respond_to do | format |
      format.html
      format.json {
        render json: @time_periods
      }
     end
  end

  def write
  end

  def destroy
  end
end
