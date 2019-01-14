class TimePeriodsController < ApplicationController
  PERMITTED_ATTRIBUTES = [
    :name,
    :uuid
  ].freeze

  def query
    time_periods = TimePeriod.all
    render json: time_periods
  end

  def read
    time_period = TimePeriod.where( uuid: params[ :uuid ] )
    render json: time_period
  end

  def write
    unless existing_time_period
      time_period = TimePeriod.new( time_period_params )

      if time_period.save
        render json: time_period
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
    else
      render json: existing_time_period
    end
  end

  def destroy
    begin
      existing_time_period.destroy

      render json: {
        message: "#{ existing_time_period.name } successfully destroyed"
      }
    rescue
      not_found_error( params )
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
