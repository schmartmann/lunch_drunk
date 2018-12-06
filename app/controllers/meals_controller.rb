class MealsController < ApplicationController
  before_action :require_time_period

  PERMITTED_ATTRIBUTES = [
    :name,
    :time_period_uuid,
    :uuid
  ].freeze

  def query
    query_helper
  end

  def read
    if existing_meal

      respond_to do | format |
        format.html
        format.json {
          render json:
           {
             meals: [
               existing_meal
             ]
           }
        }
      end
    else
      not_found_error( params )
    end
  end

  def write
    meal = time_period.meals.new(
      meal_params
    )

    if meal.save
      respond_to do | format |
        format.html {
          redirect_to meal_path( meal.uuid )
        }
        format.json {
          render json:
            {
              meals: [
                meal
              ]
            },
            status: 200
        }
      end
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
  end

  def destroy
    begin
      existing_meal.destroy

      respond_to do | format |
        format.html {
          redirect_to meals_path
        }
        format.json {
          render json: {
            message: "#{ existing_meal.name } successfully destroyed"
          }
        }
      end
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
        .joins( :ingredients )
        .where(
          uuid: params[ :uuid ]
        ).first
  end

  private; def meal_params
    params.require( :meal ).permit( PERMITTED_ATTRIBUTES )
  end

  private; def require_time_period
    unless params[ :time_period_uuid ]
      render json: {
        error: 'Missing required parameter: time_period_uuid'
      },
      status: 404
    end
  end
end
