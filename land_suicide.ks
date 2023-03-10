// Script to land on a planet with no atmosphere,
// to work efficiently the trajectory to the body should be as straight (perpendicular to surface) as possible

parameter shipheight to 6.

if (ship:availablethrust = 0) stage.

lock steering to srfRetrograde.

lock maxAcc to ship:availableThrust/ship:mass.
set gravityForceOfBody to constant():g * (body:mass / body:radius^2).

lock radarAltitude to ship:altitude - ship:geoposition:terrainheight - shipheight.

lock brakingDist to ship:velocity:surface:mag^2 / (2 * (maxAcc - gravityForceOfBody)).

ON TIME:SECOND {
  CLEARSCREEN.
  PRINT "brakingDistVert: " + brakingDist.
  PRINT "ship speed: " + ship:velocity:surface:mag.
  PRINT "maxAcc: " + maxAcc.
  PRINT "gravtitational acc: " + constant():g * (body:mass / body:radius^2).
  PRINT "time: " + time:second.
  PRINT "radarAltitude: " + radarAltitude.
  return true.
}

lock t to brakingDist / radarAltitude.
wait until t > 1.
lock throttle to t.

when radarAltitude < 200 then {
    gear on.
    return false.
}

wait until ship:status = "LANDED".
lock throttle to 0.
lock steering to up.

wait until false.