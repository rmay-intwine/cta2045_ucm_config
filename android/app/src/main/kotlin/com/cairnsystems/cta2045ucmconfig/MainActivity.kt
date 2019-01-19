package com.cairnsystems.cta2045ucmconfig

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiManager
import android.net.wifi.ScanResult
import android.support.v4.content.ContextCompat
import android.support.v4.app.ActivityCompat

import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity(): FlutterActivity() {
  private val CHANNEL = "com.cairnsystems.connectivity/ap"
  private val MY_PERMISSIONS_REQUEST_ACCESS_WIFI_STATE = 1
  private val MY_PERMISSIONS_REQUEST_CHANGE_WIFI_STATE = 2

  private val DEBUGFILTER = "Native"

  var resultList = ArrayList<ScanResult>()
  lateinit var wifiManager: WifiManager

  val broadcastReceiver = object : android.content.BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?){
      resultList = wifiManager.scanResults as ArrayList<ScanResult>
      //resultList = wifiManager.getScanResults() as ArrayList<ScanResult>
      Log.d(DEBUGFILTER, "onReceive() called - " + resultList.size)
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
                          MY_PERMISSIONS_REQUEST_ACCESS_WIFI_STATE)
        }
        else {
          startScanning()
          result.success(true)
        }
      }
      else if (call.method == "connectToAp") {
        if(ContextCompat.checkSelfPermission(this@MainActivity, android.Manifest.permission.CHANGE_WIFI_STATE)
                != android.content.pm.PackageManager.PERMISSION_GRANTED) {
          Log.d(DEBUGFILTER, "Permission not granted")
          ActivityCompat.requestPermissions(this@MainActivity,
                  arrayOf(android.Manifest.permission.CHANGE_WIFI_STATE),
                  MY_PERMISSIONS_REQUEST_CHANGE_WIFI_STATE)
        }
        else {
          Log.d(DEBUGFILTER, "Permission granted already")
          connectToAP("GuriGuest")
          result.success(true)
        }
      }
      else {
        result.notImplemented()
      }
    }

    wifiManager = this.applicationContext.getSystemService(android.content.Context.WIFI_SERVICE) as android.net.wifi.WifiManager
    //wifiManager = Context.getSystemService(android.content.Context.WIFI_SERVICE) as android.net.wifi.WifiManager
  }

  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
    when(requestCode) {
      MY_PERMISSIONS_REQUEST_ACCESS_WIFI_STATE -> {
        if ((grantResults.isNotEmpty() && grantResults[0] == android.content.pm.PackageManager.PERMISSION_GRANTED)) {
          startScanning()
        }
      }

      MY_PERMISSIONS_REQUEST_CHANGE_WIFI_STATE -> {
        Log.d(DEBUGFILTER, "Checking for wifi state permissions")
        if ((grantResults.isNotEmpty() && grantResults[0] == android.content.pm.PackageManager.PERMISSION_GRANTED)) {
          Log.d(DEBUGFILTER, "Permission was asked for and granted")
          connectToAP("GuriGuest")
        }
        else {
          Log.d(DEBUGFILTER, "Permission was asked for and not granted")
        }
      }
    }
  }

  fun connectToAP(ssid: String) {
    try {
      Log.d(DEBUGFILTER, "entering connectToAP")
      var conf: WifiConfiguration = WifiConfiguration()
      conf.SSID = "\"" + ssid + "\""
      conf.preSharedKey = "\"8MrS8rnOHV\""

      conf.status = android.net.wifi.WifiConfiguration.Status.ENABLED
      conf.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP)
      conf.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP)
      conf.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK)
      conf.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP)
      conf.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP)

      Log.d(DEBUGFILTER, "network info: " + conf.SSID + " - " + conf.preSharedKey)

      //var wifiManager: WifiManager = this.getApplicationContext().getSystemService(WIFI_SERVICE) as WifiManager
      var networkID: Int = wifiManager.addNetwork(conf)
      //wifiManager.enableNetwork(networkID, true);

      Log.d(DEBUGFILTER, "After connecting to: " + conf.SSID + " - " + conf.preSharedKey)

      var wifiList: List<WifiConfiguration> = wifiManager.getConfiguredNetworks()
      for(wifiConfig in wifiList) {
        if(wifiConfig.SSID != null && wifiConfig.SSID.compareTo("\"" + ssid + "\"") == 0) {
          wifiManager.disconnect()
          wifiManager.enableNetwork(wifiConfig.networkId, true)
          wifiManager.reconnect()

          Log.d(DEBUGFILTER, "Reconnect: " + wifiConfig.SSID)

          break;
        }
      }

      MethodChannel(flutterView, CHANNEL).invokeMethod("connectAPCallback", true)
    }
    catch (ex: Exception) {
      ex.printStackTrace()
      MethodChannel(flutterView, CHANNEL).invokeMethod("connectAPCallback", false)
    }
  }

  fun startScanning() {
    Log.d(DEBUGFILTER, "enter startScanning() asdf")
    registerReceiver(broadcastReceiver, android.content.IntentFilter(android.net.wifi.WifiManager.SCAN_RESULTS_AVAILABLE_ACTION))
    Log.d(DEBUGFILTER, "startScan()")
    wifiManager.startScan()

    Log.d(DEBUGFILTER, "handler")
    android.os.Handler().postDelayed({
      stopScanning()
    }, 7000)
  }

  fun stopScanning() {
    Log.d(DEBUGFILTER, "Enter stopScanning()")
    unregisterReceiver(broadcastReceiver)

    Log.d(DEBUGFILTER, "stopScanning() - Creating list")
    val ssidList = ArrayList<String>()
    for(result in resultList) {
      Log.d(DEBUGFILTER, "Adding SSID: " + result.SSID)
      ssidList.add(result.SSID)
    }

    Log.d(DEBUGFILTER, "Created SSID list")

    MethodChannel(flutterView, CHANNEL).invokeMethod("setSsid", ssidList)
  }
}
