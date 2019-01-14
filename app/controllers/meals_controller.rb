class MealsController < ApplicationController
  before_action :require_time_period

  PERMITTED_ATTRIBUTES = [
    :name,
    :uuid
  ].freeze

  def query
    render json: meals
  end

  def read
    render json: time_period.meals.where( uuid: params[ :uuid ] )
  end

  def shuffle
    if params[ :uuid ]
      meals = time_period.meals.where.not( uuid: params[ :uuid ] ).sample
    else
      meals = time_period.meals.sample
    end

    render json: [ meals ]
  end

  def write
    unless existing_meal
      meal = time_period.meals.new(
        meal_params
      )

      if meal.save
        render json: [ meal ]
      elsif meal.errors.any?
        render json: {
          error: meal.errors.full_messages
        },
        status: :unprocessable_entity
      else
        render json: {
          error: 'Error creating new record -- please see logs',
        },
        status: :unprocessable_entity
      end
    else
      render json: [ existing_meal ]
    end
  end

  def destroy
    begin
      existing_meal.destroy

      render json: {
        message: "#{ existing_meal.name } successfully destroyed"
      }
    rescue
      not_found_error( params )
    end
  end

  private; def time_period
    @time_period ||=
      TimePeriod.where(
        uuid: params[ :time_period_uuid ]
      ).first
  end

  private; def meals
    @meals ||= time_period.meals
  end

  private; def existing_meal
    @meal ||=
      time_period
        .meals
        .where(
          uuid: params[ :uuid ]
        ).first
  end

  private; def meal_params
    params.require( :meal ).permit( PERMITTED_ATTRIBUTES )
  end

  private; def require_time_period
    unless time_period
      render json: {
        error: 'Missing required parameter: time_period_uuid'
      },
      status: 404
    end
  end
end
