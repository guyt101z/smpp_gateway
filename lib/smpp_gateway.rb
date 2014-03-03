# Your starting point for daemon specific classes. This directory is
# already included in your load path, so no need to specify it.
require 'celluloid/autostart'
require 'em-kannel'
require 'json'
require 'rack'
require 'timers'
require 'json'
require 'pathname'
require 'simple_router'
require 'simple_router/dsl'
require 'simple_router/routes'

Rubinius::CodeLoader.require_compiled 'channel_factory'
Rubinius::CodeLoader.require_compiled 'kannel_handler'
Rubinius::CodeLoader.require_compiled 'amqp_helper'

$supervisor = Celluloid::SupervisionGroup.run!

$config['configuration']['channels'].each do |channel|
  ChannelFactory.create(channel['name'])
  
  $supervisor.pool(Object.const_get("#{channel['name'].capitalize}Channel"), as: "#{channel['name'].downcase}_channel".to_sym, args: [channel], size: channel['pool_size'])
  
end
