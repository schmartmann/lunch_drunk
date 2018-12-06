class MealsController < ApplicationController
  before_action :require_time_period

  PERMITTED_ATTRIBUTES = [
    :name,
    :time_period_uuid,
    :uuid
  ].freeze

  def query
    if meals.any?
      respond_to do | format |
        format.html
        format.json {
          render json: {
            meals: [
              meals
            ]
          }
        }
      end
    else
      render json: {
        message: "No meals found for time period #{ time_period.uuid }"
      },
      status: :not_found
    end
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
      render json: {
        error: "Could not find meal #{ params[ :uuid ] }"
      },
      status: :not_found
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
    binding.pry
  end
end
