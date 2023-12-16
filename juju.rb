class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://launchpad.net/juju/2.9/2.9.46/+download/juju-core_2.9.46.tar.gz"
  sha256 "31bde50931fb2a8411470c3e81b7f859dec115f9441080443f3659521716d1ad"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "2.9"

  depends_on "go" => :build

  def install
    cd "src/github.com/juju/juju" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/juju"
      system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: "-s -w"), "./cmd/plugins/juju-metadata"
      bash_completion.install "etc/bash_completion.d/juju"
    end
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}juju-metadata list-images 2>&1", 2)
  end
end
