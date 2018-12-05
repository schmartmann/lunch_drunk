Rails.application.routes.draw do
  get    '/time_periods',        to: 'time_periods#query'
  get    '/time_periods/:uuid',  to: 'time_periods#read'
  post   '/time_periods',        to: 'time_periods#write'
  delete '/time_periods/:uuid',  to: 'time_periods#destroy'
end
