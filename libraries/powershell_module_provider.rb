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
    raise ArgumentError, "Required attribute 'package_name' for module installation" unless @new_resource.package_name
    raise ArgumentError, "Required attribute 'destination' or 'source' for module installation" unless @new_resource.destination || @new_resource.source

    converge_by("Powershell Module '#{@powershell_module.package_name}'") do
      install_module
      Chef::Log.info("Powershell Module '#{@powershell_module.package_name}' installation completed successfully")
    end
  end

  def action_uninstall
    raise ArgumentError, "Required attribute 'package_name' for module uninstallation" unless @new_resource.package_name
    converge_by("Powershell Module '#{@powershell_module.package_name}'") do
      uninstall_module
    end
  end

  def load_current_resource
    @current_resource = PowershellModule.new(@new_resource.name)
    Dir.exist?(module_path_name) ? @current_resource.enabled(true) : @current_resource.enabled(false)
  end

  private

  def install_module
    # Check if source is a local directory or download URL
    if Dir.exist? @new_resource.source
      ps_module_path = FileUtils.mkdir_p(module_path_name).first
      Chef::Log.info("Powershell Module path folder created: #{ps_module_path}")
      @new_resource.destination(sanitize!(@new_resource.destination))
      module_dir = Dir["#{@new_resource.source}/*.psd1", "#{@new_resource.source}/*.psm1", "#{@new_resource.source}/*.dll"]
      module_dir.each do |filename|
        FileUtils.cp(filename, ps_module_path)
      end
    elsif @new_resource.source =~ URI.regexp # Check for valid URL
      download_extract_module
    end
  end

  def uninstall_module
    module_dir = module_path_name
    if Dir.exist?(module_dir)
      FileUtils.rm_rf(module_dir)
      Chef::Log.info("Powershell Module '#{@powershell_module.package_name}' uninstallation completed successfully")
    else
      Chef::Log.info("Unable to locate module '#{@new_resource.package_name}'")
    end
  end

  def download(download_url, target, limit = 10)
    uri = URI(download_url)

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      response = http.request_get(uri.path)
      case response
      when Net::HTTPSuccess then write_download(response, target)
      when Net::HTTPRedirection then download(response['location'], target, limit - 1)
      else response.error!
      end
    end
  end

  def write_download(response, target)
    ::File.open(target, 'wb') do |file|
      file.write(response.read_body)
    end
  end

  def unzip(zip_file, target_directory)
    begin
      require 'zip'
    rescue LoadError
      raise(
        'Could not load the rubyzip gem, please make sure this gem is installed with the "chef_gem" resource ' \
        'or include the powershell::default recipe before using powershell_module.'
      )
    end

    Zip::File.open(zip_file) do |zip|
      zip.each do |entry|
        FileUtils.mkdir_p(::File.join(target_directory, ::File.dirname(entry.name)))
        entry.extract(::File.join(target_directory, entry.name))
      end
    end
  end

  def download_extract_module(download_url = nil, target = nil)
    filename = @new_resource.package_name + '.zip'

    target = ::File.join(Chef::Config[:file_cache_path], filename) if target.nil?
    Chef::Log.debug("Powershell Module download target is #{target}")

    download_url = @new_resource.source if download_url.nil?
    Chef::Log.debug("Powershell Module download url is #{download_url}")

    ps_module_path = sanitize! @new_resource.destination
    Chef::Log.debug("Powershell Module ps_module_path is #{ps_module_path}")

    installed_module = module_exists?(ps_module_path, "*#{@new_resource.package_name}*")
    if installed_module
      Chef::Log.info("Powershell Module #{@new_resource.package_name} already installed.")
      Chef::Log.info("Remove path at #{ps_module_path}\\#{installed_module} to reinstall.")
    else
      download(download_url, target)
      unzip(target, ps_module_path)
      remove_download(target)
    end
  end

  def remove_download(target)
    Chef::Log.debug("Powershell Module '#{@powershell_module.package_name}' removing download #{target}")
    FileUtils.rm_f(target) if ::File.exist?(target)
  end

  def module_path_name
    ::File.join(@new_resource.destination.tr('\\', '/'), @new_resource.package_name)
  end

  def module_exists?(path, pattern)
    Dir.entries(path).find { |d| ::File.fnmatch?(pattern, d, ::File::FNM_CASEFOLD) }
  end

  def sanitize!(path)
    path.gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || '\\') if path
  end
end
