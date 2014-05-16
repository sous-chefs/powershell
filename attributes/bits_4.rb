# Cookbook Name:: powershell
# Description::   Setup attributs for bits_4
# Recipe::        bits_4
# Author::        Jeremy MAURO (j.mauro@criteo.com)
#
#
#

if node['kernel']['machine'] == 'i386'
  default['powershell']['bits_4']['url']      = 'http://download.microsoft.com/download/8/F/9/8F917766-5CBA-4B9A-81FB-10A97E851392/Windows6.0-KB960568-x86.msu'
  default['powershell']['bits_4']['checksum'] = '1df0d8ef257927b032990eb2da9690527d236e0b50ceadb5f476db632514985d'
else
  default['powershell']['bits_4']['url']      = 'http://download.microsoft.com/download/D/D/3/DD3CECA2-0866-4DFB-9873-16B5F354EB9F/Windows6.0-KB960568-x64.msu'
  default['powershell']['bits_4']['checksum'] = 'bca64cef08156b50d8d5ae7f3c29ed88f90ddd0a73594bbb29c74c87b18ff893'
end
