package weather.app.ui

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume
import skip.lib.*
import skip.foundation.*

/// An example of an external Kotlin function that can be called from Skip
fun externalKotlinFunction(): String {
    return "External Kotlin Function"
}

/// An example of using custom Kotlin to perform a location lookup. See WeatherView.swift
/// Needs AndroidManifest.xml: <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
suspend fun fetchCurrentLocation(context: Context): Pair<Double, Double> = withContext(Dispatchers.IO) {
    suspendCancellableCoroutine<Pair<Double, Double>> { continuation ->
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                val latitude = location.latitude
                val longitude = location.longitude
                locationManager.removeUpdates(this)
                continuation.resume(Pair(latitude, longitude))
            }

            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
            //override fun onProviderEnabled(provider: String?) {}
            //override fun onProviderDisabled(provider: String?) {}
        }

        var hasLocationPermission = ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        if (hasLocationPermission) {
            locationManager.requestSingleUpdate(LocationManager.GPS_PROVIDER, locationListener, Looper.getMainLooper())
        } else {
            logger.warning("no location permission")
            continuation.resume(Pair(0.0, 0.0)) // Return default location values
        }

        continuation.invokeOnCancellation {
            locationManager.removeUpdates(locationListener)
            continuation.cancel()
        }
    }
}
