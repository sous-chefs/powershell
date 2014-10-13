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
    # sorce attribute was mandatory - check?
    converge_by("Powershell Module '#{@powershell_module.package_name}'") do
      install_module
      Chef::Log.info("Powershell Module '#{@powershell_module.package_name}' installation completed successfully")
    end
  end

  def action_uninstall
    #package_name was mandatory - check?
    converge_by("Powershell Module '#{@powershell_module.package_name}'") do
      uninstall_module
    end
  end

  def load_current_resource
  end

  private

  def install_module
    fail ArgumentError, "Required attribute 'destination' or 'source' for module installation" unless @new_resource.destination || @new_resource.source

    fail ArgumentError, "Required attribute 'package_name' for module installation" unless @new_resource.package_name

    #Check if source is a local directory or download URL
    if Dir.exists? @new_resource.source
      ps_module_path = FileUtils::mkdir_p("#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/#{@new_resource.package_name}").first
      @new_resource.destination(@new_resource.destination.gsub(/\\/,"/"))
      module_dir = Dir["#{@new_resource.source}/*.psd1","#{@new_resource.source}/*.psm1","#{@new_resource.source}/*.dll"]
      module_dir.each do |filename|
        FileUtils.cp(filename, ps_module_path)
      end
    elsif(@new_resource.source =~ URI::regexp) #Check for valid URL
      # download module to temp location
      download_file = download_module()

      # extract downloaded file to $psmodulepath      
      unzip_module(download_file)

      # remove temp
      FileUtils.rm_rf(::File.dirname(download_file))
    end    
  end

  def uninstall_module
    fail ArgumentError, "Required attribute 'package_name' for module installation" unless @new_resource.package_name
    module_dir = "#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/#{@new_resource.package_name}"
    if Dir.exists?(module_dir)
      FileUtils.rm_rf(module_dir)
      Chef::Log.info("Powershell Module '#{@powershell_module.package_name}' uninstallation completed successfully")
    else
      Chef::Log.info("Unable to locate module '#{@new_resource.package_name}'")
    end
  end

  def unzip_module(download_file)
    ps_module_path = "#{ENV['PROGRAMW6432']}\\WindowsPowerShell\\Modules"       
    ps_cmd = Mixlib::ShellOut.new("powershell.exe $shell = new-object -com shell.application; $zip = $shell.NameSpace('#{download_file.gsub("/","\\\\")}'); foreach($item in $zip.items()) { $shell.Namespace('#{ps_module_path}').copyhere($item) }")
    ps_cmd.run_command
  end

  def download_module(download_url=nil, target=nil)
    target = Dir.mktmpdir + @new_resource.package_name + ".zip" if target.nil?
    download_url = @new_resource.source if download_url.nil?
    uri = URI(download_url)
    Net::HTTP.start(uri.host) do |http|
      begin
          file = open(target, 'wb')
          http.request_get(uri.request_uri) do |response|
            case response
            when Net::HTTPSuccess then
              file = open(target, 'wb')
              response.read_body do |segment|
                file.write(segment)
              end
            when Net::HTTPRedirection then
              location = response['location']
              puts "WARNING: Redirected throw #{location}"
              download_module(location, target)
            else
              puts "ERROR: Download failed. Http response code: #{response.code}"
            end
          end
      ensure
        file.close if file
      end
    end
    target
  end
end
