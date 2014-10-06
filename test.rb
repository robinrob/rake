#!/usr/bin/env ruby

$LOAD_PATH << '.'

require 'gitconfigreader'

GitConfigReader.new.read('.gitconfig_test')
