#!/bin/env ruby

require 'yaml'

repos = File.readlines('vmware_repositories.list').map { |i| i.strip! }

config = YAML.load_file(ARGV.first)

config['trackers'].find { |i| i['team_name'] == 'Bosh Ecosystem' }['repos'] = repos

File.open(ARGV.first, "w") { |file| file.write(config.to_yaml) }
