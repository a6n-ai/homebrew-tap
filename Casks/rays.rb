cask "rays" do
  version "0.1.17"
  sha256 "0292a302eca1f6add855d21a078182219e441847a815c03a03f68180f6e6b01c"

  # Through rays.a6n.ai, which counts the download and redirects to the GitHub release.
  url "https://rays.a6n.ai/download/Rays-#{version}.zip?src=brew",
      verified: "rays.a6n.ai/download/"
  name "Rays"
  desc "Small download manager with on-device AI sorting"
  homepage "https://github.com/a6n-ai/rays"

  livecheck do
    skip "Bumped by the rays release workflow."
  end

  depends_on macos: :tahoe

  app "Rays.app"
  binary "#{appdir}/Rays.app/Contents/MacOS/dl"

  # Rays isn't notarized yet; clear the download quarantine like the other casks in this tap.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Rays.app"]
  end

  # Stop sorter agents that run this cask's copy of Rays; agents from other copies are left alone.
  uninstall_preflight do
    Dir.glob(File.expand_path("~/Library/LaunchAgents/local.sorter*.plist")).each do |plist|
      next unless File.read(plist).include?("#{appdir}/Rays.app/")

      system_command "/bin/launchctl", args: ["bootout", "gui/#{Process.uid}", plist], must_succeed: false
      File.delete(plist)
    end
  end

  uninstall quit: "ai.a6n.rays"

  zap trash: [
    "~/Library/Application Support/*/*/NativeMessagingHosts/ai.a6n.rays.json",
    "~/Library/Application Support/*/NativeMessagingHosts/ai.a6n.rays.json",
    "~/Library/Application Support/Arc/User Data/NativeMessagingHosts/ai.a6n.rays.json",
    "~/Library/Application Support/Rays",
    "~/Library/Preferences/ai.a6n.rays.plist",
  ]
end
