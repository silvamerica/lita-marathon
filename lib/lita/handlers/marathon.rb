require 'marathon'

module Lita
  module Handlers
    class Marathon < Handler
      # insert handler code here
      config :url, type: String, required: true

      route(/m(?:arathon)? list(?: (\S+))?/i,
        :list_apps,
        command: true,
        restrict_to: [:deployers],
        help: {
          "m(arathon) list <filter>" => t("help.list")
      })

      route(/m(?:arathon)? count(?: (\S+))?/i,
        :count_apps,
        command: true,
        restrict_to: [:deployers],
        help: {
          "m(arathon) count <filter>" => t("help.count")
      })

      route(/m(?:arathon)? (force-)?(restart|suspend|scale) (\S+)(?: (\d+))?/i,
        :change_apps,
        command: true,
        restrict_to: [:deployers],
        help: {
          "m(arathon) (force-)restart <filter>" => t("help.restart"),
          "m(arathon) (force-)suspend <filter>" => t("help.suspend"),
          "m(arathon) (force-)scale <filter> <instances>" => t("help.scale")
      })

      def list_apps response
        filter = response.matches.flatten.first
        apps = ::Marathon::App.list(nil, nil, filter)
        response.reply render_template("list_apps", apps: apps)
      end

      def count_apps response
        filter = response.matches.flatten.first
        apps = ::Marathon::App.list(nil, "apps.taskStats", filter)
        response.reply render_template("count_apps", apps: apps)
      end

      def change_apps response
        force, command, filter, instances = response.matches.flatten
        list = ::Marathon::App.list(nil, nil, filter)
        response.reply t("response.no_apps") if list.empty?
        list.each do |app|
          begin
            case command
              when "restart"
                app.restart!(force)
              when "suspend"
                app.suspend!(force)
              when "scale"
                app.scale!(instances.to_i, force)
              else
            end
            response.reply render_template("change_app", command: command, app: app.id, instances: instances)
          rescue ::Marathon::Error::UnexpectedResponseError => e
            response.reply t("error.unexpected_response", app: app.id)
          end
        end
      end

      on :connected do
        ::Marathon.url = config.url
      end

      Lita.register_handler(self)
    end
  end
end
