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

  def read
    @time_period = TimePeriod.find_by( uuid: params[ :uuid ] )

    respond_to do | format |
      format.html
      format.json {
        render json: @time_period
      }
     end
  end

  def write
    time_period = TimePeriod.create(
      time_period_params
    )

    if time_period.valid? && time_period.uuid?
      respond_to do | format |
        format.html {
          redirect_to "/time_periods/#{ time_period.uuid }"
        }
        format.json {
          render json: time_period
        }
      end
    end
  end

  def destroy
  end

  private; def time_period_params
    params.require( :time_period ).permit( :name )
  end
end
