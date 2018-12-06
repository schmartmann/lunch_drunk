Rails.application.routes.draw do
  get    '/time_periods',        to: 'time_periods#query',    as: 'time_periods'
  get    '/time_periods/:uuid',  to: 'time_periods#read',     as: 'time_period'
  post   '/time_periods',        to: 'time_periods#write',    as: 'write_time_period'
  delete '/time_periods/:uuid',  to: 'time_periods#destroy'
end
