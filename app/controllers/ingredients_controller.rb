class IngredientsController < ApplicationController
  PERMITTED_ATTRIBUTES = [
    :name,
    :quantity,
    :unit,
    :uuid
  ].freeze

  def query
    render json: Ingredient.all
  end

  def read
    render json: Ingredient.where( uuid: params[ :uuid ] )
  end

  def write
    unless existing_ingredient
      ingredient = Ingredient.new(
        ingredient_params
      )

      if ingredient.save
        render json: ingredient
      elsif ingredient.errors.any?
        render json: {
          error: ingredient.errors.full_messages
        },
        status: :unprocessable_entity
      else
        render json: {
          error: 'Error creating new record -- please see logs'
        },
        status: :unprocessable_entity
      end
    else
      render json: existing_ingredient
    end
  end

  def destroy
    begin
      existing_ingredient.destroy

      render json: {
        message: "#{ existing_ingredient.name } successfully destroyed"
      }
    rescue
      not_found_error( params )
    end
  end

  def existing_ingredient
    @ingredient ||= Ingredient.where( ingredient_params ).first
  end

  private; def ingredient_params
    params.require( :ingredient ).permit( PERMITTED_ATTRIBUTES )
  end
end
