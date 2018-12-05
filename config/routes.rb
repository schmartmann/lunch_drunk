Rails.application.routes.draw do
    get '/time_periods', to: 'time_periods#query'
    get '/time_periods/:uuid', to: 'time_periods#read'
end
