# frozen_string_literal: true

unless defined?(Powershell::Helpers)
  module Powershell
    module Helpers
      WMF_DOWNLOADS = {
        '3.0' => {
          '6.1' => {
            'x86' => {
              url: 'http://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.1-KB2506143-x86.msu',
              checksum: '2a23cb68bc87675c8ec7c7bfdfbb7f99262b69163bc7db7edc76ac1fb436a16e',
            },
            'x64' => {
              url: 'http://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.1-KB2506143-x64.msu',
              checksum: '8a8e35fa0e613fcc54644b8336d7dabbe5c6b57a1895e9caac2d0065746d1f8d',
            },
          },
        },
        '4.0' => {
          '6.1' => {
            'x86' => {
              url: 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x86-MultiPkg.msu',
              checksum: 'd5dd77c5cd6370984257c81269ce40f83466d20339e44bb6de40c22d96641b98',
            },
            'x64' => {
              url: 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x64-MultiPkg.msu',
              checksum: 'fbc0889528656a3bc096f27434249f94cba12e413142aa38946fcdd8edf6f4c5',
            },
          },
          '6.2' => {
            'x64' => {
              url: 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows8-RT-KB2799888-x64.msu',
              checksum: 'a68da0b05dbe245510578d9affb60fd624e906d21a57bfa35741a6f677091c66',
            },
          },
        },
        '5.1' => {
          '6.1' => {
            'x86' => {
              url: 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7-KB3191566-x86.zip',
              checksum: 'eb7e2c4ce2c6cb24206474a6cb8610d9f4bd3a9301f1cd8963b4ff64e529f563',
              package: 'Win7-KB3191566-x86.msu',
              timeout: 2700,
            },
            'x64' => {
              url: 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip',
              checksum: 'f383c34aa65332662a17d95409a2ddedadceda74427e35d05024cd0a6a2fa647',
              package: 'Win7AndW2K8R2-KB3191566-x64.msu',
              timeout: 2700,
            },
          },
          '6.2' => {
            'x64' => {
              url: 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/W2K12-KB3191565-x64.msu',
              checksum: '4a1385642c1f08e3be7bc70f4a9d74954e239317f50d1a7f60aa444d759d4f49',
              timeout: 2700,
            },
          },
          '6.3' => {
            'x86' => {
              url: 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1-KB3191564-x86.msu',
              checksum: 'f3430a90be556a77a30bab3ac36dc9b92a43055d5fcc5869da3bfda116dbd817',
              timeout: 600,
            },
            'x64' => {
              url: 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu',
              checksum: 'a8d788fa31b02a999cc676fb546fc782e86c2a0acd837976122a1891ceee42c0',
              timeout: 600,
            },
          },
        },
      }.freeze

      def architecture_key
        node['kernel']['machine'] == 'x86_64' ? 'x64' : 'x86'
      end

      def nt_version
        node['platform_version'][/\A\d+\.\d+/]
      end

      def windows_server?
        node.dig('kernel', 'os_info', 'product_type') != 1
      end

      def wmf_download_details(version)
        WMF_DOWNLOADS.dig(version, nt_version, architecture_key) || {}
      end

      def supported_wmf_version?(version)
        case version
        when '2.0'
          %w(6.1 6.2).include?(nt_version)
        when '3.0'
          nt_version == '6.1'
        when '4.0'
          nt_version == '6.1' || (nt_version == '6.2' && windows_server?)
        when '5.1'
          %w(6.1 6.2 6.3).include?(nt_version) || bundled_wmf?(version)
        else
          false
        end
      end

      def bundled_wmf?(version)
        version == '5.1' && Gem::Version.new(node['platform_version']) >= Gem::Version.new('10.0')
      end

      def wow64?
        architecture_key == 'x64'
      end

      def powershell_feature_name
        nt_version == '6.2' ? 'MicrosoftWindowsPowerShellV2' : 'MicrosoftWindowsPowerShell'
      end

      def powershell_feature_wow64_name
        "#{powershell_feature_name}-WOW64"
      end

      def default_lcm_temp_dir
        "#{Chef::Config[:file_cache_path]}\\lcm_mof"
      end

      def requested_reboot?
        new_resource.reboot_mode != 'no_reboot'
      end

      def reboot_action
        new_resource.reboot_mode == 'delayed_reboot' ? :request_reboot : :reboot_now
      end
    end
  end
end
