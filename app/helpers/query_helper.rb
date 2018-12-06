module QueryHelper
  def query_helper
    existing_records = constant.all

    type_name = params[ :controller ]

    results = {
      type_name => existing_records
    }

    results.keys.each do | key |
      name = "@#{ key }".to_sym
      instance_variable_set( name, results[ key ] )
    end

    if existing_records.any?
      respond_to do | format |
        format.html
        format.json {
          render json: results
        }
      end
    else
      not_found_error( params )
    end
  end
end
