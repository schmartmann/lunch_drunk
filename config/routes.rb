Rails.application.routes.draw do
    get '/time_periods', to: 'time_periods#query'
end
