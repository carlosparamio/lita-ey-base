require "lita"

module Lita
  module Handlers
    class EyBase < Handler

      route(/ey config/i, :show_config, command: true, help: {
        "ey config" => "Displays EY configuration (apps, envs, default deploy branch, authorized users group...)"
      })

      def self.default_config(config)
        config.api_token = ""
        config.apps = {}
      end

      def self.namespace
        "ey"
      end

      def show_config(response)
        result = ""
        config.apps.each do |app_name, app_data|
          result += "App Name: #{app_name}\n"
          result += "  Environments:\n"
          app_data["envs"].each do |env_name, env_data|
            result += "    * #{env_name}\n"
            result += "      Default branch: #{env_data["default_branch"]}\n"
            result += "      Authorized users group: #{env_data["auth_group"]}\n"
          end
          result += "\n"
        end
        response.reply result
      end

    private

      def valid_app?(app)
        config.apps.keys.include?(app)
      end

      def valid_env?(app, env)
        config.apps[app]["envs"].keys.include?(env)
      end

      def required_group_to_access(app, env)
        config.apps[app]["envs"][env]["auth_group"]
      end

      def can_access?(user, app, env)
        group = required_group_to_access(app, env)
        return true unless group
        Lita::Authorization.user_in_group? user, required_group_to_access(app, env)
      end

      def access_denied_msg
        "Sorry, you don't have access; you must be at %{group_name} group."
      end

      def do_if_can_access(response, app, env, &block)
        if can_access?(response.user, app, env)
          yield
        else
          response.reply access_denied_msg % { group_name: required_group_to_access(app, env) }
        end
      end

      def default_branch_for(app, env)
        config.apps[app]["envs"][env]["default_branch"] || "master"
      end

      def ey_app(app)
        config.apps[app]["ey_name"]
      end

      def ey_env(app, env)
        config.apps[app]["envs"][env]["ey_name"]
      end

    end

    Lita.register_handler(EyBase)

  end
end
