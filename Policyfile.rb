# frozen_string_literal: true

name 'powershell'

run_list 'test::default'

cookbook 'ms_dotnet', git: 'https://github.com/criteo-cookbooks/ms_dotnet.git', branch: 'master'
cookbook 'powershell', path: '.'
cookbook 'test', path: './test/cookbooks/test'

Dir.children('./test/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, "test::#{recipe_name}"
end
