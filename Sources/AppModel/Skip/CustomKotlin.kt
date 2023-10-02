package weather.app.model

import android.content.Context
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.os.Looper
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume
import skip.lib.*
import skip.foundation.*

/// An example of using custom Kotlin to perform a location lookup. See Location.swift
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

        locationManager.requestSingleUpdate(LocationManager.GPS_PROVIDER, locationListener, Looper.getMainLooper())

        continuation.invokeOnCancellation {
            locationManager.removeUpdates(locationListener)
            continuation.cancel()
        }
    }
}

