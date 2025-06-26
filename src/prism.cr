require "./prism/**"

module Prism
  VERSION = "0.1.0"
end

if ARGV.includes?("--version")
  puts "Prism version #{Prism::VERSION}"
  exit 0
end
