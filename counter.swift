import AppKit

// Menu bar countdown timer.
// Left click: start, or reset to 30:00 and start again.
// Right click: menu with Stop, Reset and Quit.
// When done it stays on 0:00 until the next click.

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let duration: TimeInterval = 30 * 60
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private var endDate: Date?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let button = statusItem.button else { return }
        // Fixed-width digits so the item does not jiggle as it counts.
        button.font = NSFont.monospacedDigitSystemFont(
            ofSize: NSFont.menuBarFont(ofSize: 0).pointSize, weight: .regular)
        button.target = self
        button.action = #selector(clicked)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        show(duration)
    }

    @objc private func clicked() {
        let event = NSApp.currentEvent
        let isRightClick = event?.type == .rightMouseUp
            || event?.modifierFlags.contains(.control) == true
        if isRightClick {
            showMenu()
        } else {
            start()
        }
    }

    // Back to 30:00, not running.
    @objc private func stop() {
        timer?.invalidate()
        timer = nil
        endDate = nil
        show(duration)
    }

    // Start, or reset to 30:00 and keep counting.
    @objc private func start() {
        endDate = Date().addingTimeInterval(duration)
        timer?.invalidate()
        let newTimer = Timer(timeInterval: 1, target: self, selector: #selector(tick),
                             userInfo: nil, repeats: true)
        RunLoop.main.add(newTimer, forMode: .common)
        timer = newTimer
        tick()
    }

    // Uses the end time, not a counter, so it stays right after the Mac sleeps.
    @objc private func tick() {
        guard let endDate else { return }
        let remaining = endDate.timeIntervalSinceNow
        if remaining > 0 {
            show(remaining)
            return
        }
        timer?.invalidate()
        timer = nil
        self.endDate = nil
        show(0)
    }

    private func show(_ seconds: TimeInterval) {
        let total = Int(seconds.rounded(.up))
        statusItem.button?.title = String(format: "%d:%02d", total / 60, total % 60)
    }

    private func showMenu() {
        let menu = NSMenu()
        let stopItem = NSMenuItem(title: "Stop", action: #selector(stop), keyEquivalent: "")
        stopItem.target = self
        menu.addItem(stopItem)
        let resetItem = NSMenuItem(title: "Reset", action: #selector(start), keyEquivalent: "")
        resetItem.target = self
        menu.addItem(resetItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit counter",
                                action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory) // no Dock icon
app.run()
