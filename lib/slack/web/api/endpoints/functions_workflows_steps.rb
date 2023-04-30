# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

module Slack
  module Web
    module Api
      module Endpoints
        module FunctionsWorkflowsSteps
          #
          # List the steps of a specific function of a workflow's versions
          #
          # @option options [string] :function_id
          #   The ID of the function to query.
          # @option options [string] :workflow
          #   The workflow encoded ID or workflow reference.
          # @option options [string] :workflow_app_id
          #   The app tied to the workflow reference.
          # @option options [string] :workflow_id
          #   The workflow ID, starts with Wf*.
          # @see https://api.slack.com/methods/functions.workflows.steps.list
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/functions.workflows.steps/functions.workflows.steps.list.json
          def functions_workflows_steps_list(options = {})
            raise ArgumentError, 'Required arguments :function_id missing' if options[:function_id].nil?
            post('functions.workflows.steps.list', options)
          end
        end
      end
    end
  end
end
