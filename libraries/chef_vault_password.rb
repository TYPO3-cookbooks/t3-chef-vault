#
# Cookbook Name:: t3-chef-vault
# Library:: chef_vault
#
# Author: Steffen Gebert <steffen.gebert@typo3.org>
#
# Copyright (c) 2014 Steffen Gebert / TYPO3 Association.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


class Chef
  class Recipe

    # This retrieves the password for a given `user` to log into an application running
    # under a given `host` based on the node's environment, while following
    # our naming conventions.
    # By default, we search for the entry type `password`. You could pass an alternative
    # here, like "apitoken".
    #
    #
    def chef_vault_password(host, user, type = 'password')

      # strip dots from the hostname
      target_host = host.gsub(/\./, '')

      Chef::Log.debug("Password requested for user '#{user}' for host '#{target_host}'")

      # the data bag is called passwords-#{node[:chef_environment]}, while we strip
      # any "pre-" prefix (we want to map pre-production also to production passwords)
      environment = node.chef_environment.gsub(/^pre-/, '')

      bag = "passwords-#{environment}"
      item = "#{target_host}-#{user}"

      Chef::Log.info("Searching for chef-vault item '#{item}' in the '#{bag}' data bag")

      begin
        vault_answer = chef_vault_item(bag, item)
      ensure
        raise "Chef-vault did not return anything for #{bag}/#{item}" if vault_answer.nil?
      end

      Chef::Log.debug("Got answer from chef-vault")

      password = vault_answer[type]
      if password.nil?
        Chef::Log.warn("No entry '#{type}' found in #{bag}/#{item}'")
      else
        Chef::Log.debug("Returning entry '#{type}': '#{password[0..2]}...'")
      end

      password
    end

  end
end
