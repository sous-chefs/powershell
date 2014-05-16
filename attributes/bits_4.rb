#
# Author:: Jeremy MAURO (<j.mauro@criteo.com>)
# Cookbook Name:: powershell
# Attributes:: bits_4
# Copyright:: Copyright (c) 2014 Jeremy MAURO
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

if node['kernel']['machine'] == 'i386'
  default['powershell']['bits_4']['url']      = 'http://download.microsoft.com/download/8/F/9/8F917766-5CBA-4B9A-81FB-10A97E851392/Windows6.0-KB960568-x86.msu'
  default['powershell']['bits_4']['checksum'] = '1df0d8ef257927b032990eb2da9690527d236e0b50ceadb5f476db632514985d'
else
  default['powershell']['bits_4']['url']      = 'http://download.microsoft.com/download/D/D/3/DD3CECA2-0866-4DFB-9873-16B5F354EB9F/Windows6.0-KB960568-x64.msu'
  default['powershell']['bits_4']['checksum'] = 'bca64cef08156b50d8d5ae7f3c29ed88f90ddd0a73594bbb29c74c87b18ff893'
end
