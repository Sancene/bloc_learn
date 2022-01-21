package com.bloc_learn.bloc_learn

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant

import com.yandex.mapkit.MapKitFactory;

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("f02bf95b-8063-4a89-81dd-2c698bcd7050")
        super.configureFlutterEngine(flutterEngine)
    }
}
