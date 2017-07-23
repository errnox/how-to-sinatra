require 'securerandom'
require 'sinatra/base'

module Sinatra
  module Stats

    private

    def self.registered(app)
      app.set :stats_start, nil
      app.set :stats_time, nil
      app.set :stats_token, nil
      app.set :stats_no_stdout, false
      app.set :stats_no_html, false
      app.set :stats_stdout_prefix, '---------- '
    end

    public

    def stats
      before do
        settings.stats_start = Time.now
        settings.stats_time = nil
        settings.stats_token = SecureRandom.uuid + SecureRandom.uuid +
          SecureRandom.uuid + SecureRandom.uuid
      end

      after do
        settings.stats_time = Time.now - settings.stats_start
        puts "#{settings.stats_stdout_prefix}RESPONSE TIME: \
#{env['PATH_INFO']} - \ \
#{settings.stats_time}" if !settings.stats_no_stdout

        if !settings.stats_no_html
          stats_string = "<div><strong>RESPONSE TIME: </strong><em> \
#{settings.stats_time} - #{env['PATH_INFO']}</em></div>"
          # It is possible that the response body is empty or not set yet
          # (Sinatra does allow that).
          begin
            body(response.body.map(&lambda { |string|
                                     string.gsub(/#{settings.stats_token}/,
                                                 stats_string)}))
          rescue
            # Ignore.
          end
        end
      end
    end

    def statsbar
      "#{settings.stats_token}" if !settings.stats_no_html
    end
  end

  register Stats
end
