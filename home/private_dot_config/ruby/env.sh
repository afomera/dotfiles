#!/usr/bin/env sh
export RUBY_YJIT_ENABLE=1
export GEMRC="$XDG_CONFIG_HOME/ruby/gemrc"
export IRBRC="$XDG_CONFIG_HOME/ruby/irbrc"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/ruby/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/ruby/bundle"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/ruby/gem"
