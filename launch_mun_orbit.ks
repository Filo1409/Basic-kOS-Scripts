// TODO: compute if launch is possible with given deltav (on given targetapoapsis)

parameter targetapoasis is 7500.
parameter direction is 90.

set recommendeddeltav to 800.
if (ship:deltav:current < recommendeddeltav) {
    print "WARNING: current deltav (" + ship:deltav + ") is under recommended deltav (" + recommendeddeltav + ")".
}

lock radarAltitude to ship:altitude - ship:geoposition:terrainheight.
lock steering to heading(direction,90).
print "starting ...".
lock throttle to 1.

set tostage to false.
list engines in myengines.
for eng in myengines {
    on (eng:flameout) {
        set tostage to true.
    }
}

when tostage then {
    wait until stage:ready.
    print "staging ...".
    stage.
    if (stage:liquidfuel > 0 or stage:solidfuel > 0) {
        set tostage to false.
    }

    if (ship:stagenum = 1) {
        return false.
    } else {
        return true.
    }
}

when radarAltitude > 200 then {
    gear off.
    return false.
}

lock steering to heading(direction, 90 - (90 / targetapoasis) * ship:apoapsis).
wait until 0.001 * ship:apoapsis > 85 or ship:apoapsis > targetapoasis.
lock steering to heading(direction, 5).
wait until ship:apoapsis > targetapoasis.
lock throttle to 0.

wait until eta:apoapsis < 10.
lock throttle to (10 - eta:apoapsis) * 0.2.
lock steering to heading(direction, max(0, 10 - eta:apoapsis)).

wait until ship:status = "ORBITING" and ship:periapsis > targetapoasis.
print "ship is " + ship:status + " around " + orbit:body:name.