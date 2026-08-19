import SwiftUI
import WidgetKit

// Keys/App Group must match lib/core/home_widget/home_widget_service.dart
// and HomeWidget.setAppGroupId — there's no shared schema between Dart and
// Swift here, just a documented key contract.
private let appGroupId = "group.com.kappa.calorieapp.calorie_app.widget"

struct CalorieEntry: TimelineEntry {
    let date: Date
    let consumed: Int
    let target: Int
}

struct CalorieProvider: TimelineProvider {
    func placeholder(in context: Context) -> CalorieEntry {
        CalorieEntry(date: Date(), consumed: 1450, target: 2000)
    }

    func getSnapshot(in context: Context, completion: @escaping (CalorieEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalorieEntry>) -> Void) {
        let entry = readEntry()
        // The app pushes a fresh entry via HomeWidget.updateWidget on every
        // log change; this 30-minute fallback only matters if the app
        // hasn't been opened in a while.
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: entry.date)!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func readEntry() -> CalorieEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let consumed = defaults?.integer(forKey: "consumed_kcal") ?? 0
        let target = defaults?.integer(forKey: "target_kcal") ?? 0
        return CalorieEntry(date: Date(), consumed: consumed, target: target)
    }
}

struct CalorieWidgetExtensionEntryView: View {
    var entry: CalorieProvider.Entry

    private var remaining: Int { entry.target - entry.consumed }
    private var progress: Double {
        entry.target > 0 ? min(Double(entry.consumed) / Double(entry.target), 1.0) : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Calorii Fit")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(entry.consumed) / \(entry.target) kcal")
                .font(.headline)
                .bold()
            ProgressView(value: progress)
                .tint(.orange)
            Text(statusText)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var statusText: String {
        if entry.target <= 0 {
            return "Setează-ți profilul în aplicație"
        } else if remaining >= 0 {
            return "\(remaining) kcal rămase azi"
        } else {
            return "Ai depășit ținta cu \(-remaining) kcal"
        }
    }
}

struct CalorieWidgetExtension: Widget {
    let kind: String = "CalorieWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalorieProvider()) { entry in
            CalorieWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Calorii Fit")
        .description("Caloriile de azi dintr-o privire.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct CalorieWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        CalorieWidgetExtension()
    }
}
