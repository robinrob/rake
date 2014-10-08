#!/usr/bin/env ruby

$LOAD_PATH << '.'

require 'gitconfigfile'


editor = GitConfigFile.new('.gitmodules')

editor.del_block 'ruby'

editor.save