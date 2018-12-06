class TimePeriodsController < ApplicationController
  PERMITTED_ATTRIBUTES = [
    :name,
    :uuid
  ].freeze

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
    existing_time_period

    respond_to do | format |
      format.html
      format.json {
        render json:
        {
          time_periods: [
            existing_time_period
          ]
        }
      }
     end
  end

  def write
    time_period = TimePeriod.create(
      time_period_params
    )

    if time_period.save
      respond_to do | format |
        format.html {
          redirect_to time_period_path( time_period.uuid )
        }
        format.json {
          render json:
            {
              time_periods: [
                time_period
              ]
            },
            status: 200
        }
      end
    elsif time_period.errors.any?
      render json: {
        error: time_period.errors.full_messages
      },
      status: :unprocessable_entity
    else
      render json: {
        error: 'Error creating new record -- please see logs',
      },
      status: :unprocessable_entity
    end
  end

  def destroy
    begin
      existing_time_period.destroy

      respond_to do | format |
        format.html {
          redirect_to time_periods_path
        }
        format.json {
          render json: {
            message: "#{ existing_time_period.name } successfully destroyed"
          }
        }
      end
    rescue
      render json: {
        error: 'Record couldn\'t be found',
      },
      status: :not_found
    end
  end

  private; def time_period_params
    params.require( :time_period ).permit( PERMITTED_ATTRIBUTES )
  end

  private; def existing_time_period
    @time_period ||=
      TimePeriod
        .joins( :meals )
        .where(
          uuid: params[ :uuid ]
        ).first
  end
end
