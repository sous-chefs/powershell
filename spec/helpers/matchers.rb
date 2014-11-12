if defined?(ChefSpec)
  def run_powershell(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell, :run, resource_name)
  end
end
