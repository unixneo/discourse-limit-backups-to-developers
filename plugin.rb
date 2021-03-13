# frozen_string_literal: true

# name: discourse-limit-backups-to-developers
# about: Limit backups to developers
# version: 0.11
# date: 11 March 2021
# authors: Neo
# url: https://github.com/unixneo/discourse-limit-backups-to-developers

PLUGIN_NAME = "discourse-limit-backups-to-developers"
#register_asset "stylesheets/hide.css"

enabled_site_setting :enable_limit_backups_to_developers

after_initialize do
   require_relative './app/controllers/admin/backup_controller_monkey_patch'
end          

