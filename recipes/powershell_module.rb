#
# Author:: Siddheshwar More (<siddheshwar.more@clogeny.com>)
# Cookbook Name:: powershell
# Recipe:: powershell_module
#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
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

# This recipe required following environment variables to be set
# source(Mandatory) = Local directory path(Not zipfile) or URL for the zipped module folder
# package_name(Optional) = Name of the module. Should be same as the module file name. Resource name is the default value of package_name
# destination(Optional) = Location where module should be installed


#Sample code for Testing
=begin
powershell_module "PsUrl" do
  package_name "PsUrl"
  source "C:\\PsUrl"
end


# this will uninstall the ps module
powershell_module "Uninstall PsUrl" do
  package_name "PsUrl"
  action :uninstall
end
=end

powershell_module "chef-repo" do
  package_name "chef-repo"
  source "https://s3.amazonaws.com/chef-azure-extn/sid-linux-dev/chef-repo.zip"
end
