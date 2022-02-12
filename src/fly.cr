# TODO: Write documentation for `Fly::Crystal`

require "habitat"
require "http/server"

module Fly
  VERSION = "0.1.0"
  Log     = ::Log.for(self)

  Habitat.create do
    setting primary_region : String = ENV["PRIMARY_REGION"]
  end
end
