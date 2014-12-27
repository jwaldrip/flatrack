require 'rack/server'

class Flatrack
  # Provides a rake wrapper for encapsulating a flatrack site
  module Site
    extend self
    delegate :call, to: Flatrack
  end
end
