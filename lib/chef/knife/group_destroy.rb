#
# Author:: Christopher Maier (<cm@chef.io>)
# Author:: Jeremiah Snapp (<jeremiah@chef.io>)
# Copyright:: Copyright 2015-2020 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative "../knife"

class Chef
  class Knife
    class GroupDestroy < Chef::Knife
      category "group"
      banner "knife group destroy GROUP_NAME"

      deps do
        require_relative "acl_base"
        include Chef::Knife::AclBase
      end

      def run
        group_name = name_args[0]

        if name_args.length != 1
          show_usage
          ui.fatal "You must specify group name"
          exit 1
        end

        validate_member_name!(group_name)

        if %w{admins billing-admins clients users}.include?(group_name.downcase)
          ui.fatal "The '#{group_name}' group is a special group that cannot not be destroyed"
          exit 1
        end
        ui.msg "Destroying '#{group_name}' group"
        rest.delete_rest("groups/#{group_name}")
      end
    end
  end
end
