//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

<<<<<<< HEAD
=======
import file_picker
>>>>>>> 5d6a7c86a55e58bb89bc76a8c7ee0e0ae2b97e2b
import flutter_inappwebview_macos
import flutter_tts
import path_provider_foundation
import shared_preferences_foundation
import speech_to_text
<<<<<<< HEAD
import sqflite
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
=======
import sqflite_darwin
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FilePickerPlugin.register(with: registry.registrar(forPlugin: "FilePickerPlugin"))
>>>>>>> 5d6a7c86a55e58bb89bc76a8c7ee0e0ae2b97e2b
  InAppWebViewFlutterPlugin.register(with: registry.registrar(forPlugin: "InAppWebViewFlutterPlugin"))
  FlutterTtsPlugin.register(with: registry.registrar(forPlugin: "FlutterTtsPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SpeechToTextPlugin.register(with: registry.registrar(forPlugin: "SpeechToTextPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
