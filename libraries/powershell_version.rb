require 'chef/dsl/registry_helper'

module Powershell
  class PowershellVersionHelper
    include Chef::DSL::RegistryHelper

    def run_context
      Chef.run_context
    end

    def powershell_version?(versionstring)
      Gem::Version.new(powershell_version) >= Gem::Version.new(versionstring)
    end

    def powershell_version
      reg_keys = [{ key: 'HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine', value: 'PowerShellVersion' },
                  { key: 'HKLM\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine', value: 'PowerShellVersion' }]
      reg_keys.each do |x|
        return registry_get_values(x[:key]).find { |i| i[:name] == x[:value] }[:data] if
          registry_key_exists?(x[:key]) &&
          registry_value_exists?(x[:key], name: x[:value], type: :string)
      end
      nil
    end
  end

  module VersionHelper
    def self.powershell_version
      Powershell::PowershellVersionHelper.new.powershell_version
    end

    def self.powershell_version?(versionstring = nil)
      Powershell::PowershellVersionHelper.new.powershell_version?(versionstring)
    end
  end
end unless defined?(Powershell::VersionHelper)
