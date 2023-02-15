// TODO: compute if landing is possible with remaining deltav
// if not: maybe compute if possible when doing landing maneuver on apoapsis?

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
    if (ship:periapsis > 0) {
        set tostage to false.
    }

    if (ship:stagenum = 1) {
        return false.
    } else {
        return true.
    }
}

lock steering to srfRetrograde.

wait until vang(ship:facing:forevector, steering:forevector) < 1.

lock throttle to 1.
wait until ship:periapsis < 0.
lock throttle to 0.
wait 0.
set tostage to true.

WHEN (NOT CHUTESSAFE) THEN {
    CHUTESSAFE ON.
    RETURN (NOT CHUTES).
}

wait until ship:status = "LANDED" or ship:status = "SPLASHED".
print "ship is " + ship:status + " on " + orbit:body:name.