package com.kappa.calorieapp.calorie_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

// Reads the same key/value pairs the Flutter side writes via
// HomeWidgetService.update (see lib/core/home_widget/home_widget_service.dart)
// — kept in sync manually since there's no shared schema between Dart and
// Kotlin here, just a documented key contract.
class CalorieWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val consumed = widgetData.getInt("consumed_kcal", 0)
        val target = widgetData.getInt("target_kcal", 0)
        val remaining = target - consumed
        val progress = if (target > 0) ((consumed * 100) / target).coerceIn(0, 100) else 0

        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.calorie_widget)
            views.setTextViewText(R.id.widget_calories_text, "$consumed / $target kcal")
            views.setProgressBar(R.id.widget_progress_bar, 100, progress, false)
            views.setTextViewText(
                R.id.widget_remaining_text,
                if (target <= 0) "Setează-ți profilul în aplicație"
                else if (remaining >= 0) "$remaining kcal rămase azi"
                else "Ai depășit ținta cu ${-remaining} kcal",
            )
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
