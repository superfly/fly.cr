# fly.cr

[Fly.io multi-region postgres support](https://fly.io/docs/getting-started/multi-region-databases)
for crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     fly:
       github: grepsedawk/fly.cr
       version: ~> 0.1
   ```

2. Run `shards install`

## Usage

### Postgres via Avram

1. Add [Multi-region postgres](https://fly.io/docs/getting-started/multi-region-databases/#add-read-replicas)
   regional database readers and multi-region web application deployments via fly.io
1. Configure primary (writer) region by setting ENV `$PRIMARY_REGION`
1. Require `fly/pg/error_handler` and `fly/avram` _after_ avram

   ```crystal
   # src/shards.cr
   # ...
   require "avram"
   # ...
   require "fly/pg/error_handler"
   require "fly/avram"
   # ...
   ```

   This will add patching into avram in order to automatically change the port
   to read only port (5433) when the `ENV["FLY_REGION"]`, set automatically
   by fly.io, based on your `Fly` configuration.

1. Add middleware to your HTTP stack. This supports any core Crystal HTTP server.
   The middleware must appear after any Error Handler middleware, such as the
   `Lucky::ErrorHandler`.

   For Lucky, this looks like this:

   ```crystal
     def middleware : Array(HTTP::Handler)
       [
         # ...
         Lucky::ErrorHandler.new(action: Errors::Show),
         Raven::Lucky::ErrorHandler.new,
         Fly::PG::ErrorHandler.new,
         # ..,.
       ] of HTTP::Handler
     end
   ```

## Configuration (Optional)

To override the use of `ENV['PRIMARY_REGION']`, you can set the Fly primary region
by writing a fly config:

```crystal
# config/fly.cr
Fly.configure do |settings|
   settings.primary_region = ENV["WRITER_REGION"] # Can be any string
end
```

## Development

For now, make a Fly.io deploy using [lucky_jumpstart](https://github.com/stephendolan/lucky_jumpstart)
and use that to test.

It's a bit of a pain because deploys take 3-5min, but it's the best development
option as it provides integration testing.

## Contributing

1. Fork it (<https://github.com/grepsedawk/fly-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Alex Piechowski](https://github.com/grepsedawk) - creator and maintainer
