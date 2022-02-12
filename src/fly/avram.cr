require "../fly"

class Avram::Credentials
  private def set_url_port(io)
    if Fly.settings.primary_region == ENV["FLY_REGION"]
      previous_def(io)
    else
      io << ":5433"
    end
  end
end
