module Prism
  module Lsp

    enum Kind
      Text = 1
      Method = 2
      Function = 3
      Constructor = 4
      Field = 5
      Variable = 6
      Class = 7
      Interface = 8
      Module = 9
      Property = 10
      Unit = 11
      Value = 12
      Enum = 13
      Keyword = 14
      Snippet = 15
      Color = 16
      File = 17
      Reference = 18
      Folder = 19
      EnumMember = 20
      Constant = 21
      Struct = 22
      Event = 23
      Operator = 24
      TypeParameter = 25
    end

    module Handler

      private def self._completion(server : Server, message : Message) : Message?
        completions = [
          {
            "label" => "puts",
            "kind" => Kind::Function.value,
            "detail" => "puts(object) : Nil",
            "documentation" => "Prints objects to STDOUT"
          },
          {
            "label" => "p",
            "kind" => Kind::Function.value,
            "detail" => "p(object) : Nil",
            "documentation" => "Prints the inspect representation of an object"
          },
          {
            "label" => "def",
            "kind" => Kind::Keyword.value,
            "detail" => "def method_name",
            "documentation" => "Define a method"
          },
          {
            "label" => "class",
            "kind" => Kind::Keyword.value,
            "detail" => "class ClassName",
            "documentation" => "Define a class"
          },
          {
            "label" => "module",
            "kind" => Kind::Keyword.value,
            "detail" => "module ModuleName",
            "documentation" => "Define a module"
          },
          {
            "label" => "require",
            "kind" => Kind::Keyword.value,
            "detail" => "require 'library'",
            "documentation" => "Load a library or file"
          }
        ]

        result = JSON.parse(%({"items": #{completions.to_json}}))

        Message.new(
          jsonrpc: "2.0",
          id: message.id,
          result: result
        )
      end

    end
  end
end
