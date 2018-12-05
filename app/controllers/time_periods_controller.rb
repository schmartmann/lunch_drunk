class TimePeriodsController < ApplicationController
  def query
    @time_periods = TimePeriod.all
  end

  def write
  end

  def destroy
  end
end
