Rails.application.routes.draw do
  get    '/time_periods',        to: 'time_periods#query',    as: 'time_periods'
  get    '/time_periods/:uuid',  to: 'time_periods#read',     as: 'time_period'
  post   '/time_periods',        to: 'time_periods#write',    as: 'write_time_period'
  delete '/time_periods/:uuid',  to: 'time_periods#destroy',  as: 'destroy_time_period'

  get    '/time_periods/:time_period_uuid/meals',          to: 'meals#query',    as: 'meals'
  get    '/time_periods/:time_period_uuid/meals_shuffle',  to: 'meals#shuffle',  as: 'meals_shuffle'
  get    '/time_periods/:time_period_uuid/meals/:uuid',    to: 'meals#read',     as: 'meal'
  post   '/time_periods/:time_period_uuid/meals',          to: 'meals#write',    as: 'write_meal'
  delete '/time_periods/:time_period_uuid/meals/:uuid',    to: 'meals#destroy',  as: 'destroy_meal'

  get    '/ingredients',         to: 'ingredients#query',    as: 'ingredients'
  get    '/ingredients/:uuid',   to: 'ingredients#read',     as: 'ingredient'
  post   '/ingredients',         to: 'ingredients#write',    as: 'write_ingredient'
  delete '/ingredients/:uuid',   to: 'ingredients#destroy',  as: 'destroy_ingredient'

  get    '/meal_ingredients',       to: 'meal_ingredients#query', as: 'meal_ingredients'
  post   '/meal_ingredients',       to: 'meal_ingredients#write',
                                    as: 'write_meal_ingredient'

  delete '/meal_ingredients/:uuid', to: 'meal_ingredients#destroy',
                                    as: 'destroy_meal_ingredients'

end
