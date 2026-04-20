# Testing

Run unit tests with:

```text
cookstyle
chef exec rspec --format documentation
```

Run the default integration suite locally with Vagrant:

```text
kitchen test default-windows-2019 --destroy=always
```

Run the CI-style integration suite locally with the exec driver:

```text
KITCHEN_LOCAL_YAML=kitchen.exec.yml kitchen test default-windows-2019 --destroy=always
```
