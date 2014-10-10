#!/usr/bin/env ruby

$LOAD_PATH << '.'

require 'gitconfigfile'

puts GitConfigFile.new(:filename => '.gitmodules').serialize