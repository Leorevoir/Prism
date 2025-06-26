require "json"

module Prism

  module Lsp

    struct Message

      getter jsonrpc : String
      getter id : Int32 | String | Nil
      getter method : String?
      getter params : JSON::Any?
      getter result : JSON::Any?
      getter error : JSON::Any?

      def initialize(@jsonrpc : String, @id : Int32 | String | Nil = nil, @method : String? = nil, @params : JSON::Any? = nil, @result : JSON::Any? = nil, @error : JSON::Any? = nil)
      end

      def to_json(json : JSON::Builder)
        json.object {
          json.field "jsonrpc", @jsonrpc
          json.field "id", @id if @id
          json.field "method", @method if @method
          json.field "params", @params if @params
          json.field "result", @result if @result
          json.field "error", @error if @error
        }
      end

    end

  end

end
