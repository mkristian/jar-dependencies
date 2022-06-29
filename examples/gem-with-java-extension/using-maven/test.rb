# frozen_string_literal: true

# setup env
$LOAD_PATH << 'lib'

# load our gem
require 'mygem'

# use it
puts Java::App.hello('world')
