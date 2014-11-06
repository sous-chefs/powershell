#
# Author:: Siddheshwar More (<siddheshwar.more@clogeny.com>)
#
# Copyright:: 2014, Chef, Inc.
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

require_relative 'powershell_module_resource'
require 'tmpdir'
require 'net/http'
require 'chef'
require 'chef/mixin/shell_out'
require 'uri'

class PowershellModuleProvider < Chef::Provider
  include Chef::Mixin::ShellOut

  def initialize(powershell_module, run_context)
    super(powershell_module, run_context)
    @powershell_module = powershell_module
  end

  def action_install
    fail ArgumentError, "Required attribute 'package_name' for module installation" unless @new_resource.package_name
    fail ArgumentError, "Required attribute 'destination' or 'source' for module installation" unless @new_resource.destination || @new_resource.source

    converge_by("Powershell Module '#{@powershell_module.package_name}'") do
      install_module
      Chef::Log.info("Powershell Module '#{@powershell_module.package_name}' installation completed successfully")
    end
  end

  def action_uninstall
    fail ArgumentError, "Required attribute 'package_name' for module uninstallation" unless @new_resource.package_name
    converge_by("Powershell Module '#{@powershell_module.package_name}'") do
      uninstall_module
    end
  end

  def load_current_resource
    @current_resource = PowershellModule.new(@new_resource.name)
    Dir.exist?(@new_resource.destination + @new_resource.package_name) ? @current_resource.enabled(true) : @current_resource.enabled(false)
  end

  private

  def install_module
    # Check if source is a local directory or download URL
    if Dir.exist? @new_resource.source
      ps_module_path = FileUtils.mkdir_p("#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/#{@new_resource.package_name}").first
      @new_resource.destination(@new_resource.destination.gsub(/\\/, '/'))
      module_dir = Dir["#{@new_resource.source}/*.psd1", "#{@new_resource.source}/*.psm1", "#{@new_resource.source}/*.dll"]
      module_dir.each do |filename|
        FileUtils.cp(filename, ps_module_path)
      end
    elsif @new_resource.source =~ URI.regexp # Check for valid URL
      downloaded_file = download_extract_module

      # remove temp
      FileUtils.rm_rf(::File.dirname(downloaded_file))
    end
  end

  def uninstall_module
    module_dir = "#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/#{@new_resource.package_name}"
    if Dir.exist?(module_dir)
      FileUtils.rm_rf(module_dir)
      Chef::Log.info("Powershell Module '#{@powershell_module.package_name}' uninstallation completed successfully")
    else
      Chef::Log.info("Unable to locate module '#{@new_resource.package_name}'")
    end
  end

  def download_extract_module(download_url = nil, target = nil)
    target = Dir.mktmpdir + @new_resource.package_name + '.zip' if target.nil?
    download_url = @new_resource.source if download_url.nil?

    ps_module_path = "#{ENV['PROGRAMW6432']}\\WindowsPowerShell\\Modules"
    cmd_str = "powershell.exe Invoke-WebRequest #{download_url} -OutFile #{target}; $shell = new-object -com shell.application;$zip = $shell.NameSpace('#{target.gsub('/', '\\\\')}'); $shell.Namespace('#{ps_module_path}').copyhere($zip.items(), 0x14);write-host $shell"

    ps_cmd = Mixlib::ShellOut.new(cmd_str)
    ps_cmd.run_command

    target
  end
end
