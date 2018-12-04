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
          startScanning()
          result.success(true)
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
          startScanning()
        }
      }
    }
  }

  fun startScanning() {
    registerReceiver(broadcastReceiver, android.content.IntentFilter(android.net.wifi.WifiManager.SCAN_RESULTS_AVAILABLE_ACTION))
    wifiManager.startScan()

    android.os.Handler().postDelayed({
      stopScanning()
    }, 7000)
  }

  fun stopScanning() {
    unregisterReceiver(broadcastReceiver)
    val ssidList = ArrayList<String>()
    for(result in resultList) {
      ssidList.add(result.SSID)
    }

    MethodChannel(flutterView, CHANNEL).invokeMethod("setSsid", ssidList)
  }
}
