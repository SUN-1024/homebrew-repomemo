class Repomemo < Formula
  desc "Git-neutral continuity layer for agent-native project directories"
  homepage "https://github.com/SUN-1024/repomemo"
  url "https://github.com/SUN-1024/repomemo/releases/download/v2.0.3/repomemo.js"
  sha256 "ebc969471de60b48799c4e89f12a79ef1d99cd9300bd02da301606a3c0771131"
  license "MIT"

  depends_on "node@22"

  def install
    libexec.install "repomemo.js"
    chmod 0755, libexec/"repomemo.js"
    (bin/"repomemo").write_env_script libexec/"repomemo.js", PATH: formula_opt_bin("node@22")
  end

  test do
    assert_match "repomemo #{version}", shell_output("#{bin}/repomemo --version")

    target = testpath/"plain project"
    target.mkpath
    system bin/"repomemo", "init", "--target", target
    system bin/"repomemo", "doctor", "--target", target

    assert_predicate target/"AGENTS.md", :file?
    assert_predicate target/"AGENT_STATE.md", :file?
    assert_predicate target/".agents/skills/README.md", :file?
    refute_path_exists target/".git"
  end
end
