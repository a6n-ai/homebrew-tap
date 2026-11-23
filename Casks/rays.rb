cask "rays" do
  version "0.1.15"
  sha256 "162f5b046d163e4d374adcff4c7b7a8ec2e31871e021436c6654611bc68ac0a6"

  url "https://github.com/a6n-ai/rays/releases/download/v#{version}/Rays-#{version}.dmg"
  name "Rays"
  desc "Download manager with a built-in file sorter"
  homepage "https://rays.a6n.ai/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :tahoe

  app "Rays.app"
  binary "#{appdir}/Rays.app/Contents/MacOS/dl"

  # Rays is not notarized; without this Gatekeeper blocks the first launch.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Rays.app"]
  end

  zap trash: [
    "~/Library/Application Support/Rays",
    "~/Library/LaunchAgents/local.sorter*.plist",
    "~/Library/Preferences/ai.a6n.rays.plist",
  ]
end
