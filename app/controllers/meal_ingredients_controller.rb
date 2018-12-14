class MealIngredientsController < ApplicationController

    PERMITTED_ATTRIBUTES = [
      :uuid,
      :meal_id,
      :ingredient_id,
      :ingredient_ids
    ].freeze

    def query
      ingredient_ids = params[ :ingredient_ids ]
      meal_ids = params[ :meal_ids ]

      if ingredient_ids
        @meals = []

        MealIngredient.
          where(
            ingredient_id: ingredient_ids
          ).each do | meal_ingredient |
            @meals << meal_ingredient
          end

      elsif meal_ids
        @ingredients = []

        MealIngredient.
          where(
            ingredient_id: ingredient_ids
          ).each do | meal_ingredient |
            @meals << meal_ingredient
          end
      end
    end

    def write
      unless existing_meal_ingredient
        meal_ingredient = MealIngredient.new(
          meal_ingredient_params
        )

        if meal_ingredient.save
          render json: {
            meal_ingredient: existing_meal_ingredient
          }
        elsif meal_ingredient.errors.any?
          render json: {
            error: meal_ingredient.errors.full_messages
          },
          status: :unprocessable_entity
        end
      else
        render json: {
          meal_ingredient: existing_meal_ingredient
        }
      end
    end

    def destroy
      meal_ingredient =
        MealIngredient
          .find_by( uuid: meal_ingredient_params[ :uuid ] )

      if meal_ingredient && meal_ingredient.destroy
        render json: {
          message: "meal_ingredient #{ meal_ingredient.uuid } successfully destroyed"
        }
      else
        not_found_error( params )
      end
    end

    def existing_meal
      @meal ||= Meal.find( meal_ingredient_params[ :meal_id ] ) rescue nil
    end

    def existing_ingredient
      @ingredient ||= Ingredient.find( meal_ingredient_params[ :ingredient_id ] ) rescue nil
    end

    def existing_meal_ingredient
      @meal_ingredient ||=
        MealIngredient
          .where(
            meal: existing_meal,
            ingredient: existing_ingredient
          ).first
    end

    private; def meal_ingredient_params
      params.require( :meal_ingredient ).permit( PERMITTED_ATTRIBUTES )
    end
end
