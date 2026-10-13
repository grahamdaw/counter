# counter

A 30-minute countdown timer that lives in the macOS menu bar.

- **Left click:** start the timer, or reset it to 30:00 and start again.
- **Right click** (or Control-click): a menu with Stop, Reset and Quit counter.
- When the timer finishes it shows `0:00` until you click it again.

It has no Dock icon and no window, only the menu bar item.

## Requirements

- macOS on a Mac (it uses AppKit)
- The Xcode Command Line Tools, which provide `swiftc`:

```sh
xcode-select --install
```

## Build

```sh
./build.sh
```

This compiles `counter.swift` and creates `counter.app` in this folder.

If you get `permission denied`, make the script executable first:

```sh
chmod +x build.sh
```

## Run

```sh
open counter.app
```

The timer appears in the menu bar showing `30:00`.

## Deploy (install on your Mac)

1. Build the app (see above).
2. Copy it into Applications:

   ```sh
   cp -R counter.app /Applications/
   ```

3. Start it:

   ```sh
   open /Applications/counter.app
   ```

### Start automatically at login

Open **System Settings → General → Login Items**, click **+** under
"Open at Login", and choose `/Applications/counter.app`.

### Update to a new version

```sh
osascript -e 'quit app "counter"'   # or right click the timer → Quit counter
./build.sh
rm -rf /Applications/counter.app
cp -R counter.app /Applications/
open /Applications/counter.app
```

### Uninstall

Quit counter, remove it from Login Items, then:

```sh
rm -rf /Applications/counter.app
```

## Installing on another Mac

The app is not code-signed or notarized. If you copy `counter.app` to a
different Mac, Gatekeeper will block it the first time. Either build it on
that Mac with `./build.sh`, or clear the quarantine flag after copying:

```sh
xattr -dr com.apple.quarantine /Applications/counter.app
```

You can also right click the app in Finder, choose **Open**, then confirm.

The binary is built for the Mac's own CPU type (Apple silicon or Intel), so
build on a Mac with the same CPU type as the one you are copying to.

## Troubleshooting

### `error: redefinition of module 'SwiftBridging'`

This is a bug in some Command Line Tools releases (for example 16.4), not in
counter. Two files in the toolchain define the same module. Fix it in one of
these ways:

- Update or reinstall the Command Line Tools:

  ```sh
  sudo rm -rf /Library/Developer/CommandLineTools
  xcode-select --install
  ```

- Or move the duplicate file aside:

  ```sh
  sudo mv /Library/Developer/CommandLineTools/usr/include/swift/module.modulemap \
          /Library/Developer/CommandLineTools/usr/include/swift/module.modulemap.bak
  ```

Then run `./build.sh` again.
