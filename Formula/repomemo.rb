class Repomemo < Formula
  desc "Git-neutral continuity layer for agent-native project directories"
  homepage "https://github.com/SUN-1024/repomemo"
  url "https://github.com/SUN-1024/repomemo/releases/download/v2.0.0/repomemo.js"
  version "2.0.0"
  sha256 "c51c1b60e206a0a859e421fd5f06cf0e0a1cf8a99c194c73f9e3093cbb5581c1"
  license "MIT"

  depends_on "node@22"

  def install
    libexec.install "repomemo.js"
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
