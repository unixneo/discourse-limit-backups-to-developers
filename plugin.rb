# frozen_string_literal: true

# name: discourse-limit-backups-to-developers
# about: Limit backups to developers
# version: 0.0.1
# date: 11 March 2021
# authors: Neo
# url: https://github.com/unixneo/discourse-limit-backoups-to-developers

PLUGIN_NAME = "discourse-limit-backups-to-developers"

enabled_site_setting :enable_limit_backups_to_developers

after_initialize do
end          

