package com.cairnsystems.cta2045ucmconfig

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.net.wifi.WifiManager
import android.net.wifi.ScanResult
import android.support.v4.content.ContextCompat
import android.support.v4.app.ActivityCompat

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity(): FlutterActivity() {
  private val CHANNEL = "com.cairnsystems.connectivity/ap"
  private val LOGLABEL = "Kotlin"
  private val MY_PERMISSIONS_REQUEST_COARSE_LOCATION = 1

  var resultList = ArrayList<ScanResult>()
  lateinit var wifiManager: WifiManager

  val broadcastReceiver = object : android.content.BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?){
      resultList = wifiManager.scanResults as ArrayList<ScanResult>
    }
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "getApList") {
        if(ContextCompat.checkSelfPermission(this@MainActivity, android.Manifest.permission.ACCESS_COARSE_LOCATION)
        != android.content.pm.PackageManager.PERMISSION_GRANTED) {
          ActivityCompat.requestPermissions(this@MainActivity,
                  arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION),
                          MY_PERMISSIONS_REQUEST_COARSE_LOCATION)
        }
        else {
          android.util.Log.d(LOGLABEL, "Native called")
          doTheThing()
          val returnValue = getResult()
          result.success(returnValue)
        }
      } else {
        result.notImplemented()
      }
    }

    wifiManager = this.applicationContext.getSystemService(android.content.Context.WIFI_SERVICE) as android.net.wifi.WifiManager
  }

  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
    when(requestCode) {
      MY_PERMISSIONS_REQUEST_COARSE_LOCATION -> {
        if ((grantResults.isNotEmpty() && grantResults[0] == android.content.pm.PackageManager.PERMISSION_GRANTED)) {
          doTheThing()
        }
      }
    }
  }

  fun doTheThing() {
    android.util.Log.d(LOGLABEL, "Doing the thing")
    startScanning()
  }

  fun startScanning() {
    android.util.Log.d(LOGLABEL, "startScanning")
    registerReceiver(broadcastReceiver, android.content.IntentFilter(android.net.wifi.WifiManager.SCAN_RESULTS_AVAILABLE_ACTION))
    android.util.Log.d(LOGLABEL, "Register receiver")
    wifiManager.startScan()
    android.util.Log.d(LOGLABEL, "Scanning started")

    android.os.Handler().postDelayed({
      stopScanning()
    }, 10000)
  }

  fun stopScanning() {
    android.util.Log.d(LOGLABEL, "stopScanning")
    unregisterReceiver(broadcastReceiver)
    val axisList = ArrayList<Pair<String, Int>>()
    for(result in resultList) {
      axisList.add(Pair(result.SSID, result.level))
    }

    android.util.Log.d(LOGLABEL, "--- Start Results ---")
    android.util.Log.d(LOGLABEL, axisList.toString())
    android.util.Log.d(LOGLABEL, "--- End Results ---")
  }

  private fun getResult(): String {
    return "This is a result from native Kotlin."
  }
}
