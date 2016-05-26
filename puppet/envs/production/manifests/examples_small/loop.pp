$binaries = ["run", "build", "update", "foo"]

$binaries.each |String $binary| {
  file {"/usr/local/bin/myapp-$binary":
    ensure => link,
    target => "/opt/myapp/bin/$binary",
  }
}
