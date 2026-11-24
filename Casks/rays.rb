cask "rays" do
  version "0.1.19"
  sha256 "fe2d7578544e2a2e82a240d6a4d38312aced02475c350a15322ad61a602c2a8c"

  # Through rays.a6n.ai, which counts the download and redirects to the GitHub release.
  url "https://rays.a6n.ai/download/Rays-#{version}.zip?src=brew"
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
  uninstall_preflight_steps do
    run "/bin/sh",
        args:           [
          "-c",
          <<~SH,
            for plist in "$HOME"/Library/LaunchAgents/local.sorter*.plist; do
              grep -qF "$1" "$plist" 2>/dev/null || continue
              /bin/launchctl bootout "gui/$(id -u)" "$plist"
              rm -f "$plist"
            done
          SH
          "sh",
          "{{appdir}}/Rays.app/",
        ],
        must_succeed:   false,
        writable_paths: ["Library/LaunchAgents"],
        writable_base:  :home
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
