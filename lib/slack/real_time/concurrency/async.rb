require 'async/websocket'
require 'async/notification'
require 'async/clock'

module Slack
  module RealTime
    module Concurrency
      module Async
        class Client < ::Async::WebSocket::Client
          extend ::Forwardable
          def_delegators :@driver, :on, :text, :binary, :emit
        end

        class Socket < Slack::RealTime::Socket
          attr_reader :client

          def start_sync(client)
            start_reactor(client).wait
          end

          def start_async(client)
            Thread.new do
              start_reactor(client)
            end
          end

          def start_reactor(client)
            client.logger.warn(client) { 'start_reactor' }
            Async do |task|
              client.logger.warn([client, task].map(&:to_s).join(', ')) { 'creating async::notification' }
              @restart = ::Async::Notification.new

              if client.run_ping?
                client.logger.warn([client, task].map(&:to_s).join(', ')) { 'creating ping worker' }
                @ping_task = task.async do |subtask|
                  subtask.annotate 'client keep-alive'

                  # The timer task will naturally exit after the driver is set to nil.
                  while @restart
                    client.logger.warn([client, subtask].map(&:to_s).join(', ')) { "restart is #{@restart}, sleeping #{client.websocket_ping}" }
                    subtask.sleep client.websocket_ping
                    client.logger.warn([client, subtask].map(&:to_s).join(', ')) { "restart is #{@restart}, run_ping!" }
                    client.run_ping! if @restart
                  end
                  client.logger.warn([client, subtask].map(&:to_s).join(', ')) { "restart is #{@restart}, terminating" }
                end
              end

              while @restart
                client.logger.warn([client, task].map(&:to_s).join(', ')) { "restart is #{@restart}, client_task is #{@client_task}" }
                @client_task.stop if @client_task

                @client_task = task.async do |subtask|
                  begin
                    subtask.annotate 'client run-loop'
                    client.logger.warn([client, subtask].map(&:to_s).join(', ')) { "starting loop" }
                    client.run_loop
                    client.logger.warn([client, subtask].map(&:to_s).join(', ')) { "loop ended" }
                  rescue ::Async::Wrapper::Cancelled => e
                    # Will get restarted by ping worker.
                    client.logger.warn([client, subtask].map(&:to_s).join(', ')) { e.message }
                  end
                end

                @restart.wait
                client.logger.warn([client, task].map(&:to_s).join(', ')) { "@restart.wait is over" }
              end

              client.logger.warn([client, task].map(&:to_s).join(', ')) { "@ping_task is #{@ping_task}" }
              @ping_task.stop if @ping_task
            end
          end

          def restart_async(client, new_url)
            @url = new_url
            @last_message_at = current_time

            client.logger.warn(client) { "@url=#{@url}, @last_message_at=#{@last_message_at}, restart=#{@restart}" }
            @restart.signal if @restart
          end

          def current_time
            ::Async::Clock.now
          end

          def connect!
            super
            run_loop
          end

          # Kill the restart/ping loop.
          def disconnect!
            super
          ensure
            if restart = @restart
              @restart = nil
              restart.signal
            end
          end

          # Close the socket.
          def close
            super
          ensure
            if @socket
              @socket.close
              @socket = nil
            end
          end

          def run_loop
            while @driver && @driver.next_event
              # $stderr.puts event.inspect
            end
          end

          protected

          def build_ssl_context
            OpenSSL::SSL::SSLContext.new(:TLSv1_2_client).tap do |ctx|
              ctx.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER)
            end
          end

          def build_endpoint
            endpoint = ::Async::IO::Endpoint.tcp(addr, port)
            endpoint = ::Async::IO::SSLEndpoint.new(endpoint, ssl_context: build_ssl_context) if secure?
            endpoint
          end

          def connect_socket
            build_endpoint.connect
          end

          def connect
            @socket = connect_socket
            @driver = Client.new(@socket, url)
          end
        end
      end
    end
  end
end
