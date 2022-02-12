require "../../fly"

class Fly::PG::ErrorHandler
  include HTTP::Handler

  delegate primary_region, to: Fly.settings

  def call(context : HTTP::Server::Context)
    call_next(context)
  rescue error : PQ::PQError
    raise error unless read_only_sql_transaction?(error)

    Log.info { "Replaying request in region #{primary_region}" }
    context.response.status_code = 409
    context.response.headers["fly-replay"] = "region=#{primary_region}"
  end

  def read_only_sql_transaction?(error : PQ::PQError)
    error.fields.find do |field|
      field.message == "25006" && field.name == :code
    end
  end
end
