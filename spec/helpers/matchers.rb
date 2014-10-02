if defined?(ChefSpec)
  def run_dsc_script(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dsc_script, :run, resource_name)
  end

  def run_powershell(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell, :run, resource_name)
  end
end
