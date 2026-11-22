cask "rays" do
  version "0.1.9"
  sha256 "01ece5a58c3eda6027a271ace432524956923c46cf169f0121aea75e51c03eec"

  url "https://github.com/a6n-ai/rays/releases/download/v#{version}/Rays-#{version}.zip"
  name "Rays"
  desc "Small download manager with on-device AI sorting"
  homepage "https://github.com/a6n-ai/rays"

  livecheck do
    skip "Bumped by the rays release workflow."
  end

  depends_on macos: ">= :tahoe"

  app "Rays.app"
  binary "#{appdir}/Rays.app/Contents/MacOS/dl"

  # Rays isn't notarized yet; clear the download quarantine like the other casks in this tap.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Rays.app"]
  end

  # Stop sorter agents that run the installed Rays' sorter; agents from other copies are left alone.
  uninstall_preflight do
    Dir.glob(File.expand_path("~/Library/LaunchAgents/local.sorter*.plist")).each do |plist|
      # Only agents that run this cask's copy; a Rays built elsewhere keeps its agents.
      next unless File.read(plist).include?("#{appdir}/Rays.app/")

      system_command "/bin/launchctl", args: ["bootout", "gui/#{Process.uid}", plist], must_succeed: false
      File.delete(plist)
    end
  end

  uninstall quit: "ai.a6n.rays"

  zap trash: [
    "~/Library/Application Support/Rays",
    "~/Library/Preferences/ai.a6n.rays.plist",
    "~/Library/Application Support/*/NativeMessagingHosts/ai.a6n.rays.json",
    "~/Library/Application Support/*/*/NativeMessagingHosts/ai.a6n.rays.json",
    "~/Library/Application Support/Arc/User Data/NativeMessagingHosts/ai.a6n.rays.json",
  ]
end
