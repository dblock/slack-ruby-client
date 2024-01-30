# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

module Slack
  module Web
    module Api
      module Endpoints
        module Search
          #
          # Searches for messages and files matching a query.
          #
          # @option options [string] :query
          #   Search query. May contains booleans, etc.
          # @option options [boolean] :highlight
          #   Pass a value of true to enable query highlight markers (see below).
          # @option options [string] :sort
          #   Return matches sorted by either score or timestamp.
          # @option options [enum] :sort_dir
          #   Change sort direction to ascending (asc) or descending (desc).
          # @option options [string] :team_id
          #   encoded team id to search in, required if org token is used.
          # @see https://api.slack.com/methods/search.all
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/search/search.all.json
          def search_all(options = {})
            raise ArgumentError, 'Required arguments :query missing' if options[:query].nil?
            post('search.all', options)
          end

          #
          # Searches for files matching a query.
          #
          # @option options [string] :query
          #   Search query.
          # @option options [boolean] :highlight
          #   Pass a value of true to enable query highlight markers (see below).
          # @option options [string] :sort
          #   Return matches sorted by either score or timestamp.
          # @option options [enum] :sort_dir
          #   Change sort direction to ascending (asc) or descending (desc).
          # @option options [string] :team_id
          #   encoded team id to search in, required if org token is used.
          # @see https://api.slack.com/methods/search.files
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/search/search.files.json
          def search_files(options = {})
            raise ArgumentError, 'Required arguments :query missing' if options[:query].nil?
            post('search.files', options)
          end

          #
          # Searches for messages matching a query.
          #
          # @option options [string] :query
          #   Search query.
          # @option options [string] :cursor
          #   Use this when getting results with cursormark pagination. For first call send * for subsequent calls, send the value of next_cursor returned in the previous call's results.
          # @option options [boolean] :highlight
          #   Pass a value of true to enable query highlight markers (see below).
          # @option options [string] :sort
          #   Return matches sorted by either score or timestamp.
          # @option options [enum] :sort_dir
          #   Change sort direction to ascending (asc) or descending (desc).
          # @option options [string] :team_id
          #   encoded team id to search in, required if org token is used.
          # @see https://api.slack.com/methods/search.messages
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/search/search.messages.json
          def search_messages(options = {})
            raise ArgumentError, 'Required arguments :query missing' if options[:query].nil?
            if block_given?
              Pagination::Cursor.new(self, :search_messages, options).each do |page|
                yield page
              end
            else
              post('search.messages', options)
            end
          end
        end
      end
    end
  end
end
