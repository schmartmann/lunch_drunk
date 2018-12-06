class IngredientsController < ApplicationController
  PERMITTED_ATTRIBUTES = [
    :name,
    :quantity,
    :unit,
    :uuid
  ].freeze

  def query
    if existing_ingredients.any?
      respond_to do | format |
        format.html
        format.json {
          render json: {
            ingredients: existing_ingredients
          }
        }
      end
    else
      render json: {
        message: "No ingredients found"
      },
      status: :not_found
    end
  end

  def read
    if existing_ingredient
      respond_to do | format |
        format.html
        format.json {
          render json: {
            ingredients: [
              existing_ingredient
            ]
          }
        }
      end
    else
      not_found_error( params )
    end
  end

  def write
    ingredient = Ingredient.new(
      ingredient_params
    )

    if ingredient.save
      respond_to do | format |
        format.html {
          redirect_to ingredient_path( ingredient.uuid )
        }
        format.json {
          render json:
            {
              ingredients: [
                ingredient
              ]
            },
            status: 200
        }
      end
    elsif ingredient.errors.any?
      render json: {
        error: ingredient.errors.full_messages
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
      existing_ingredient.destroy

      respond_to do | format |
        format.html {
          redirect_to ingredients_path
        }
        format.json {
          render json: {
            message: "#{ existing_ingredient.name } successfully destroyed"
          }
        }
      end
    rescue
      not_found_error( params )
    end
  end

  def existing_ingredients
    @ingredients ||= Ingredient.all
  end

  def existing_ingredient
    @ingredient ||=
      Ingredient
        .where(
          uuid: params[ :uuid ]
        ).first
  end

  private; def ingredient_params
    params.require( :ingredient ).permit( PERMITTED_ATTRIBUTES )
  end
end
