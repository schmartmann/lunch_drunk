Rails.application.routes.draw do
  get    '/time_periods',        to: 'time_periods#query',    as: 'time_periods'
  get    '/time_periods/:uuid',  to: 'time_periods#read',     as: 'time_period'
  post   '/time_periods',        to: 'time_periods#write',    as: 'write_time_period'
  delete '/time_periods/:uuid',  to: 'time_periods#destroy',  as: 'destroy_time_period'

  get    '/meals',          to: 'meals#query',    as: 'meals'
  get    '/meals_shuffle',  to: 'meals#shuffle',  as: 'meals_shuffle'
  get    '/meals/:uuid',    to: 'meals#read',     as: 'meal'
  post   '/meals',          to: 'meals#write',    as: 'write_meal'
  delete '/meals/:uuid',    to: 'meals#destroy',  as: 'destroy_meal'

  get    '/ingredients',         to: 'ingredients#query',    as: 'ingredients'
  get    '/ingredients/:uuid',   to: 'ingredients#read',     as: 'ingredient'
  post   '/ingredients',         to: 'ingredients#write',    as: 'write_ingredient'
  delete '/ingredients/:uuid',   to: 'ingredients#destroy',  as: 'destroy_ingredient'
  get    '/ingredients_filter',  to: 'ingredients#filter',   as: 'filter_ingredient'

  post   '/meal_ingredients',       to: 'meal_ingredients#write',
                                    as: 'write_meal_ingredient'

  delete '/meal_ingredients/:uuid', to: 'meal_ingredients#destroy',
                                    as: 'destroy_meal_ingredients'

end
