#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

action :run do
  begin
    script_file.puts(@new_resource.code)
    script_file.close
    # always set the ExecutionPolicy flag
    # see http://technet.microsoft.com/en-us/library/ee176961.aspx
    # Powershell will hang if stdin is redirected
    # http://connect.microsoft.com/PowerShell/feedback/details/572313/powershell-exe-can-hang-if-stdin-is-redirected
    flags = "#{@new_resource.flags} -ExecutionPolicy RemoteSigned -inputformat none -Command".strip

    # cwd hax...shell_out on windows needs to support proper 'cwd'
    # follow CHEF-2357 for more
    cwd = @new_resource.cwd ? "cd #{@new_resource.cwd} & " : ""
    command = "#{cwd}#{@new_resource.interpreter} #{flags} \"#{build_powershell_scriptblock}\""

    execute.command(command)
    execute.creates(@new_resource.creates)
    execute.user(@new_resource.user)
    execute.group(@new_resource.group)
    execute.timeout(@new_resource.timeout)
    execute.returns(@new_resource.returns)
    execute.run_action(:run)
  ensure
    unlink_script_file
  end
end

private

def execute
  @execute ||= Chef::Resource::Execute.new(@new_resource.name, run_context)
end

def script_file
  @script_file ||= Tempfile.open(['chef-script', '.ps1'])
end

def unlink_script_file
  @script_file && @script_file.close!
end

# take advantage of PowerShell scriptblocks
# to pass scoped environment variables to the
# command
def build_powershell_scriptblock
  # environment var hax...shell_out on windows needs to support proper 'environment'
  # follow CHEF-2358 for more
  env_string = if @new_resource.environment
    @new_resource.environment.inject("") {|a, (k,v)| a << "$#{k} = '#{v}'; "; a}
  else
    ""
  end
  "& { #{env_string}#{ensure_windows_friendly_path(script_file.path)} }"
end

def ensure_windows_friendly_path(path)
  if path
    path.gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
  else
    path
  end
end
