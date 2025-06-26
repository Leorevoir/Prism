module Prism
  module Lsp
    module Handler
      alias Func = Proc(Server, Message, Message?)

      @@handlers = {} of String => Func

      def self.register
        @@handlers["initialize"]              = ->(srv : Server, msg : Message) : Message? { _initialize(srv, msg) }
        @@handlers["initialized"]             = ->(srv : Server, msg : Message) : Message? { _initialized(srv, msg) }
        @@handlers["shutdown"]                = ->(srv : Server, msg : Message) : Message? { _shutdown(srv, msg) }
        @@handlers["exit"]                    = ->(srv : Server, msg : Message) : Message? { _exit(srv, msg) }
        @@handlers["textDocument/didOpen"]    = ->(srv : Server, msg : Message) : Message? { _did_open(srv, msg) }
        @@handlers["textDocument/didChange"]  = ->(srv : Server, msg : Message) : Message? { _did_change(srv, msg) }
        @@handlers["textDocument/didSave"]    = ->(srv : Server, msg : Message) : Message? { _did_save(srv, msg) }
        @@handlers["textDocument/didClose"]   = ->(srv : Server, msg : Message) : Message? { _did_close(srv, msg) }
        @@handlers["textDocument/completion"] = ->(srv : Server, msg : Message) : Message? { _completion(srv, msg) }
        @@handlers["textDocument/hover"]      = ->(srv : Server, msg : Message) : Message? { _hover(srv, msg) }
        @@handlers["textDocument/definition"] = ->(srv : Server, msg : Message) : Message? { _definition(srv, msg) }
      end

      def self.call(server : Server, message : Message) : Message?
        @@handlers[message.method]?.try &.call(server, message)
      end

      private def self._initialize(server : Server, message : Message) : Message?
        capabilities = JSON.parse(%(
          {
        "textDocumentSync": {
          "openClose": true,
          "change": 2,
          "save": true
        },
        "completionProvider": {
          "resolveProvider": false,
          "triggerCharacters": ["."]
        },
        "hoverProvider": true,
        "definitionProvider": true,
        "documentSymbolProvider": true,
        "workspaceSymbolProvider": true
          }
        ))
        result = JSON.parse(%(
          {
        "capabilities": #{capabilities.to_json},
        "serverInfo": {
          "name": "crystal-lsp",
          "version": "0.1.0"
        }
          }
        ))
        server.initialized = true

        Message.new(
          jsonrpc: "2.0",
          id: message.id,
          result: result
        )
      end

      private def self._initialized(server : Server, message : Message) : Message?
        server.initialized = true
        nil
      end

      private def self._shutdown(server : Server, message : Message) : Message?
        server.shutdown = true
        nil
      end

      private def self._exit(server : Server, message : Message) : Message?
        server.shutdown = true
        nil
      end

      private def self._did_open(server : Server, message : Message) : Message?
        if params = message.params
          if text_document = params["textDocument"]?
            uri = text_document["uri"].as_s
            text = text_document["text"].as_s

            # TODO: send diagnostics
            server.reply(uri, [] of JSON::Any)
          end
        end
        nil
      end

      private def self._did_change(server : Server, message : Message) : Message?
        if params = message.params
          if text_document = params["textDocument"]?
            uri = text_document["uri"].as_s

            # TODO: update diagnostics
          end
        end
        nil
      end

      private def self._did_save(server : Server, message : Message) : Message?
        if params = message.params
          if text_document = params["textDocument"]?
            uri = text_document["uri"].as_s
          end
        end
        nil
      end

      private def self._did_close(server : Server, message : Message) : Message?
        if params = message.params
          if text_document = params["textDocument"]?
            uri = text_document["uri"].as_s
          end
        end
        nil
      end

      private def self._completion(server : Server, message : Message) : Message?
        completions = [
          {
            "label" => "puts",
            "kind" => 3,
            "detail" => "puts(object) : Nil",
            "documentation" => "Prints objects to STDOUT"
          },
          {
            "label" => "p",
            "kind" => 3,
            "detail" => "p(object) : Nil",
            "documentation" => "Prints the inspect representation of an object"
          },
          {
            "label" => "def",
            "kind" => 14,
            "detail" => "def method_name",
            "documentation" => "Define a method"
          },
          {
            "label" => "class",
            "kind" => 7,
            "detail" => "class ClassName",
            "documentation" => "Define a class"
          },
          {
            "label" => "module",
            "kind" => 9,
            "detail" => "module ModuleName",
            "documentation" => "Define a module"
          }
        ]

        result = JSON.parse(%({"items": #{completions.to_json}}))

        Message.new(
          jsonrpc: "2.0",
          id: message.id,
          result: result
        )
      end

      private def self._hover(server : Server, message : Message) : Message?
        hover_content = {
          "contents" => {
            "kind" => "markdown",
            "value" => "**Crystal Language Server**\n\nBasic hover information for Crystal code."
          }
        }

        result = JSON.parse(hover_content.to_json)

        Message.new(
          jsonrpc: "2.0",
          id: message.id,
          result: result
        )
      end

      private def self._definition(server : Server, message : Message) : Message?
        result = JSON.parse("null")

        Message.new(
          jsonrpc: "2.0",
          id: message.id,
          result: result
        )
      end
    end
  end
end
