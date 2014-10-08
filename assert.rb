require 'exceptions'

def assert &block
  raise AssertionError unless yield
end