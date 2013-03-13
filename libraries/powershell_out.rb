class Chef
  module Mixin
    module PowershellOut
      include Chef::Mixin::ShellOut

      def powershell_out(script, options)
        flags = [
          # Hides the copyright banner at startup.
          "-NoLogo",
          # Does not present an interactive prompt to the user.
          "-NonInteractive",
          # Does not load the Windows PowerShell profile.
          "-NoProfile",
          # always set the ExecutionPolicy flag
          # see http://technet.microsoft.com/en-us/library/ee176961.aspx
          "-ExecutionPolicy RemoteSigned",
          # Powershell will hang if STDIN is redirected
          # http://connect.microsoft.com/PowerShell/feedback/details/572313/powershell-exe-can-hang-if-stdin-is-redirected
          "-InputFormat None"
        ]

        command = "#{locate_sysnative_cmd("windowspowershell\\v1.0\\powershell.exe")} #{flags.join(' ')} -Command \"#{script}\""
        shell_out(command, options)
      end

      def powershell_out!(script, options)
        flags = [
          # Hides the copyright banner at startup.
          "-NoLogo",
          # Does not present an interactive prompt to the user.
          "-NonInteractive",
          # Does not load the Windows PowerShell profile.
          "-NoProfile",
          # always set the ExecutionPolicy flag
          # see http://technet.microsoft.com/en-us/library/ee176961.aspx
          "-ExecutionPolicy RemoteSigned",
          # Powershell will hang if STDIN is redirected
          # http://connect.microsoft.com/PowerShell/feedback/details/572313/powershell-exe-can-hang-if-stdin-is-redirected
          "-InputFormat None"
        ]

        command = "#{locate_sysnative_cmd("windowspowershell\\v1.0\\powershell.exe")} #{flags.join(' ')} -Command \"#{script}\""
        shell_out!(command, options)
      end

      private
      # account for Window's wacky File System Redirector
      # http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85).aspx
      # especially important for 32-bit processes (like Ruby) on a 
      # 64-bit instance of Windows.
      def locate_sysnative_cmd(cmd)
        if ::File.exists?("#{ENV['WINDIR']}\\sysnative\\#{cmd}")
          "#{ENV['WINDIR']}\\sysnative\\#{cmd}"
        elsif ::File.exists?("#{ENV['WINDIR']}\\system32\\#{cmd}")
          "#{ENV['WINDIR']}\\system32\\#{cmd}"
        else
          cmd
        end
      end
    end
  end
end
