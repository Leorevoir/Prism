COLOR_RESET     = "\e[0m"
COLOR_BOLD     = "\e[1m"
COLOR_ITALIC   = "\e[3m"
COLOR_DEBUG    = "\e[38;5;188m"
COLOR_INFO     = "\e[38;5;183m"
COLOR_WARN     = "\e[38;5;216m"
COLOR_ERROR    = "\e[38;5;203m"
COLOR_CONTEXT  = "\e[38;5;138m"

module Prism

  module Log

    macro debug(message)
      {% if flag?(:debug) %}
        ::Prism::Log.emit(
          {{message}},
          __LINE__,
          __FILE__,
          level: :debug,
          color: COLOR_DEBUG,
          style: COLOR_BOLD
        )
      {% end %}
    end

    macro info(message)
      ::Prism::Log.emit(
        {{message}},
        __LINE__,
        __FILE__,
        level: :info,
        color: COLOR_INFO,
        style: COLOR_BOLD
      )
    end

    macro warn(message)
      ::Prism::Log.emit(
        {{message}},
        __LINE__,
        __FILE__,
        level: :warn,
        color: COLOR_WARN,
        style: COLOR_BOLD
      )
    end

    macro error(message)
      ::Prism::Log.emit(
        {{message}},
        __LINE__,
        __FILE__,
        level: :error,
        color: COLOR_ERROR,
        style: COLOR_BOLD
      )
    end

    def self.emit(message, line, file, *, level : Symbol, color : String, style : String)

      timestamp = Time.local.to_s("%H:%M:%S.%L")
      basename = File.basename(file)

      puts [
        "#{style}#{color}[#{level.to_s.upcase}]\t",
        "#{COLOR_CONTEXT}#{timestamp} #{basename}:#{line}#{COLOR_RESET}",
        "#{style}#{color}#{message}#{COLOR_RESET}"
      ].join(" ")
    end
  end

end
