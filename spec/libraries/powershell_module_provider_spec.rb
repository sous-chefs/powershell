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

require_relative '../../libraries/powershell_module_provider'
require 'tmpdir'

describe 'PowershellModuleProvider' do
  before do
    @node = Chef::Node.new
    @events = Chef::EventDispatch::Dispatcher.new
    @run_context = Chef::RunContext.new(@node, {}, @events)
    @new_resource = PowershellModule.new('testmodule', @run_context)
    @provider = PowershellModuleProvider.new(@new_resource, @run_context)
  end

  describe 'action_install:' do
    it 'install module' do
      expect(@provider).to receive(:install_module)
      expect { @provider.run_action(:install) }.to_not raise_error
    end
  end

  describe 'action_uninstall:' do
    it 'uninstall module' do
      @provider.should_receive(:uninstall_module)
      expect { @provider.run_action(:uninstall) }.to_not raise_error
    end
  end

  describe 'load_current_resource:' do
    before do
      @current_resource = PowershellModule.new('testmodule', @run_context)
    end

    it 'current resource is enabled' do
      directory = @new_resource.destination + @new_resource.package_name
      expect(PowershellModule).to receive(:new).with('testmodule').and_return(@current_resource)
      expect(Dir).to receive(:exist?).with(directory).and_return(true)

      @provider.load_current_resource
      expect(@current_resource.enabled).to eq(true)
    end

    it 'current resource is disabled' do
      directory = @new_resource.destination + @new_resource.package_name
      expect(PowershellModule).to receive(:new).with('testmodule').and_return(@current_resource)
      expect(Dir).to receive(:exist?).with(directory).and_return(false)

      @provider.load_current_resource
      expect(@current_resource.enabled).to eq(false)
    end
  end

  describe 'download_extract_module:' do
    context 'when download_url and target are nil' do
      before do
        ENV['PROGRAMW6432'] = 'C:\\PROGRAMW6432'
        @ps_cmd = double
      end

      it 'downloads the package' do
        expect(Dir).to receive(:mktmpdir).and_return('C:/tmp/')
        cmd_str = "powershell.exe Invoke-WebRequest testmodule -OutFile C:/tmp/testmodule.zip; $shell = new-object -com shell.application;$zip = $shell.NameSpace('C:\\tmp\\testmodule.zip'); $shell.Namespace('C:\\PROGRAMW6432\\WindowsPowerShell\\Modules').copyhere($zip.items(), 0x14);write-host $shell"
        expect(Mixlib::ShellOut).to receive(:new).with(cmd_str).and_return(@ps_cmd)
        expect(@ps_cmd).to receive(:run_command)

        expect(@provider.send(:download_extract_module)).to eq('C:/tmp/testmodule.zip')
      end
    end

    context 'when download_url is provided and target is nil' do
      before do
        ENV['PROGRAMW6432'] = 'C:\\PROGRAMW6432'
        @ps_cmd = double
      end

      it 'downloads the package' do
        expect(Dir).to receive(:mktmpdir).and_return('C:/tmp/')
        cmd_str = "powershell.exe Invoke-WebRequest https://temp_download.com -OutFile C:/tmp/testmodule.zip; $shell = new-object -com shell.application;$zip = $shell.NameSpace('C:\\tmp\\testmodule.zip'); $shell.Namespace('C:\\PROGRAMW6432\\WindowsPowerShell\\Modules').copyhere($zip.items(), 0x14);write-host $shell"
        expect(Mixlib::ShellOut).to receive(:new).with(cmd_str).and_return(@ps_cmd)
        expect(@ps_cmd).to receive(:run_command)

        expect(@provider.send(:download_extract_module, 'https://temp_download.com')).to eq('C:/tmp/testmodule.zip')
      end
    end

    context 'when download_url is nil and target is provided' do
      before do
        ENV['PROGRAMW6432'] = 'C:\\PROGRAMW6432'
        @ps_cmd = double
      end

      it 'downloads the package' do
        cmd_str = "powershell.exe Invoke-WebRequest testmodule -OutFile tmp/target1.zip; $shell = new-object -com shell.application;$zip = $shell.NameSpace('tmp\\target1.zip'); $shell.Namespace('C:\\PROGRAMW6432\\WindowsPowerShell\\Modules').copyhere($zip.items(), 0x14);write-host $shell"
        expect(Mixlib::ShellOut).to receive(:new).with(cmd_str).and_return(@ps_cmd)
        expect(@ps_cmd).to receive(:run_command)

        expect(@provider.send(:download_extract_module, nil, 'tmp/target1.zip')).to eq('tmp/target1.zip')
      end
    end

    context 'when download_url and target are provided' do
      before do
        ENV['PROGRAMW6432'] = 'C:\\PROGRAMW6432'
        @ps_cmd = double
      end

      it 'downloads the package' do
        cmd_str = "powershell.exe Invoke-WebRequest https://temp_download.com -OutFile tmp/target1.zip; $shell = new-object -com shell.application;$zip = $shell.NameSpace('tmp\\target1.zip'); $shell.Namespace('C:\\PROGRAMW6432\\WindowsPowerShell\\Modules').copyhere($zip.items(), 0x14);write-host $shell"
        expect(Mixlib::ShellOut).to receive(:new).with(cmd_str).and_return(@ps_cmd)
        expect(@ps_cmd).to receive(:run_command)

        expect(@provider.send(:download_extract_module, 'https://temp_download.com', 'tmp/target1.zip')).to eq('tmp/target1.zip')
      end
    end
  end

  describe 'uninstall_module:' do
    context 'when module directory exists' do
      before do
        ENV['PROGRAMW6432'] = 'C:/PROGRAMW6432'
        @ps_cmd = double
      end

      it 'uninstalls module' do
        module_dir = 'C:/PROGRAMW6432/WindowsPowerShell/Modules/testmodule'
        expect(Dir).to receive(:exist?).with(module_dir).and_return(true)
        expect(FileUtils).to receive(:rm_rf).with(module_dir)
        expect(Chef::Log).to receive(:info).with("Powershell Module 'testmodule' uninstallation completed successfully")

        expect(@provider.send(:uninstall_module))
      end
    end

    context 'when module directory does not exist' do
      before do
        ENV['PROGRAMW6432'] = 'C:/PROGRAMW6432'
        @ps_cmd = double
      end

      it 'logs message' do
        module_dir = 'C:/PROGRAMW6432/WindowsPowerShell/Modules/testmodule'
        expect(Dir).to receive(:exist?).with(module_dir).and_return(false)
        expect(Chef::Log).to receive(:info).with("Unable to locate module 'testmodule'")

        expect(@provider.send(:uninstall_module))
      end
    end
  end

  describe 'install_module:' do
    before do
      ENV['PROGRAMW6432'] = 'C:/PROGRAMW6432'
      @ps_cmd = double
    end

    context 'install from local source' do
      before do
        @dir = Dir.tmpdir + '/testmodule'
        FileUtils.mkdir_p(@dir) unless File.directory?(@dir)
        @module_files = ["#{@dir}/test.psd1", "#{@dir}/test.psm1", "#{@dir}/test.dll"]
        @module_files.each do |file|
          File.new("#{file}", 'w+')
        end
      end

      after do
        FileUtils.rm_rf(@dir) if File.directory?(@dir)
      end

      it 'copies module from source to ps module path' do
        @new_resource.source(@dir)
        ps_module_path = 'C:/PROGRAMW6432/WindowsPowerShell/Modules/testmodule'
        expect(Dir).to receive(:exist?).with('/tmp/testmodule').and_return(true)

        expect(FileUtils).to receive(:mkdir_p).with(ps_module_path).and_return(["#{ps_module_path}"])
        @module_files.each do |filename|
          expect(FileUtils).to receive(:cp).with(filename, ps_module_path)
        end

        @provider.send(:install_module)
      end
    end
    context 'source is a url' do
      it 'downloads module from source and install' do
        @new_resource.source('https://testmodule.com')
        expect(@provider).to receive(:download_extract_module).and_return('C:/tmp/testmodule')
        expect(FileUtils).to receive(:rm_rf).with('C:/tmp')
        @provider.send(:install_module)
      end
    end
  end
end
