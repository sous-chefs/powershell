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

class PowershellModuleProvider < Chef::Provider
  def initialize(powershell_module, run_context)
    super(powershell_module, run_context)
    @powershell_module = powershell_module
  end

  def action_install
    converge_by("Powershell Module '#{@powershell_module.module_name}'") do
      install_module
      Chef::Log.info("Powershell Module '#{@powershell_module.module_name}' installation completed successfully")
    end
  end

  def load_current_resource
  end

  private

  def install_module
    fail ArgumentError, "Required attribute 'module_path' or 'download_from' for module installation" unless @new_resource.module_path || @new_resource.download_from

    fail ArgumentError, "Required attribute 'module_name' for module installation" unless @new_resource.module_name

    if @new_resource.module_path
      ps_module_path = FileUtils::mkdir_p("#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/#{@new_resource.module_name}").first
      @new_resource.module_path(@new_resource.module_path.gsub(/\\/,"/"))
      module_dir = Dir["#{@new_resource.module_path}/*.psd1","#{@new_resource.module_path}/*.psm1","#{@new_resource.module_path}/*.dll"]
      module_dir.each do |filename|
        FileUtils.cp(filename, ps_module_path)
      end
    end

    if @new_resource.download_from
      # download module to temp location
      download_file = download_module()

      # extract downloaded file to $psmodulepath
      ensure_rubyzip_gem_installed
      unzip_module(download_file)

      # remove temp
      FileUtils.rm_rf(::File.dirname(download_file))
    end
  end

  def ensure_rubyzip_gem_installed
    begin
      require 'zip'
    rescue LoadError
      Chef::Log.info("Missing gem 'rubyzip'...installing now.")
      chef_gem "rubyzip" do
        version node['windows']['rubyzipversion']
      end
      require 'zip'
    end
  end

  def unzip_module(download_file)
    ps_module_path = "#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/"
    Zip::File.open(download_file) do |zip|
      zip.each do |entry|
        path = ::File.join(ps_module_path, entry.name)
        FileUtils.mkdir_p(::File.dirname(path))
        if ::File.exists?(path)
          FileUtils.rm(path)
        end
        zip.extract(entry, path)
      end
    end
  end

  def download_module(download_url=nil, target=nil)
    target = Dir.mktmpdir + @new_resource.module_name if target.nil?
    download_url = @new_resource.download_from if download_url.nil?
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
