Mime::Type.register "application/vnd.api+json", :json_api

ActionDispatch::Request.parameter_parsers[:json_api] = ->(raw_post) do
  JSON.parse(raw_post)
end