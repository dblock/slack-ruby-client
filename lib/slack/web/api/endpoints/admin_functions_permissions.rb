# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

module Slack
  module Web
    module Api
      module Endpoints
        module AdminFunctionsPermissions
          #
          # Lookup the visibility of multiple Slack functions and include the users if it is limited to particular named entities.
          #
          # @option options [array] :function_ids
          #   An array of function IDs to get permissions for.
          # @see https://api.slack.com/methods/admin.functions.permissions.lookup
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/admin.functions.permissions/admin.functions.permissions.lookup.json
          def admin_functions_permissions_lookup(options = {})
            raise ArgumentError, 'Required arguments :function_ids missing' if options[:function_ids].nil?
            post('admin.functions.permissions.lookup', options)
          end

          #
          # Set the visibility of a Slack function and define the users or workspaces if it is set to named_entities
          #
          # @option options [string] :function_id
          #   The function ID to set permissions for.
          # @option options [enum] :visibility
          #   The function visibility.
          # @option options [array] :user_ids
          #   List of user IDs to allow for named_entities visibility.
          # @see https://api.slack.com/methods/admin.functions.permissions.set
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/admin.functions.permissions/admin.functions.permissions.set.json
          def admin_functions_permissions_set(options = {})
            raise ArgumentError, 'Required arguments :function_id missing' if options[:function_id].nil?
            raise ArgumentError, 'Required arguments :visibility missing' if options[:visibility].nil?
            post('admin.functions.permissions.set', options)
          end
        end
      end
    end
  end
end
