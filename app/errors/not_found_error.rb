module NotFoundError
  PARAMS_TO_SCRUB = [
    :controller,
    :action
  ]

  def not_found_error( params )
    class_name = params[ :controller ].singularize

    params = params[ class_name ]

    if params
      keys = params.keys

      message = "#{ class_name } not be found "

      if keys.any?
        params_description = ''

        params.keys.each do | key |
          params_description.concat(
            "#{ key }: #{ params[ key ] } "
          )
        end

        message.concat(
          "for params: #{ params_description }"
        )
      end
    end
    render json: {
      error: message
    }, status: :not_found
  end
end
