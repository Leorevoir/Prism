module Prism

  module Lsp

    class Server

      property initialized : Bool = false
      property shutdown : Bool = false
      property exit : Bool = false

      def initialize(@stdin : IO = STDIN, @stdout : IO = STDOUT)
        Handler.register
      end

      def start
        Log.info "server started"
        loop {
          break if @shutdown
          begin
            if msg = receive
              if response = Handler.call(self, msg)
                reply(response)
              end
            end
          rescue ex : Exception
            Log.debug "exception: #{ex.class} - #{ex.message}"
          end
        }
      end

      private def receive : Message?
        length = 0

        loop {
          line = @stdin.gets
          return nil unless line

          line = line.strip
          if line.empty?
            break
          elsif line.starts_with?("Content-Length:")
            length = line.split(":")[1].strip.to_i
          end
        }

        return nil if length == 0

        content = @stdin.read_string(length)
        json = JSON.parse(content)

        Message.new(
          jsonrpc: json["jsonrpc"].as_s,
          id: json["id"]?.try(&.as_i) || json["id"]?.try(&.as_s),
          method: json["method"]?.try(&.as_s),
          params: json["params"]?
        )
        rescue ex : JSON::ParseException
          Log.error "Failed to parse JSON message: #{ex.message}"
          nil
      end

      def reply(message : Prism::Lsp::Message)
        content = message.to_json
        @stdout.print "Content-Length: #{content.bytesize}\r\n\r\n#{content}"
        @stdout.flush
      end

      def reply(uri : String, diagnostics : Array(JSON::Any))
        params = {
          "uri" => uri,
          "diagnostics" => diagnostics
        }

        notification = Prism::Lsp::Message.new(
          jsonrpc: "2.0",
          method: "textDocument/publishDiagnostics",
          params: JSON.parse(params.to_json)
        )

        reply(notification)
      end

    end

  end

end
