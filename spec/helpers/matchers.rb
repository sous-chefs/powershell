if defined?(ChefSpec)
  def run_powershell(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell, :run, resource_name)
  end

  def install_powershell_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell_package, :install, resource_name)
  end

  def update_powershell_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell_package, :update, resource_name)
  end

  def uninstall_powershell_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell_package, :uninstall, resource_name)
  end

  def install_powershell_package_provider(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell_package_provider, :install, resource_name)
  end

  def register_powershell_package_source(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell_package_source, :register, resource_name)
  end

  def unregister_powershell_package_source(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell_package_source, :unregister, resource_name)
  end

  def update_powershell_package_source(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:powershell_package_source, :update, resource_name)
  end
end
