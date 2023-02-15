// TODO: compute if launch is possible with given deltav (on given targetapoapsis)

parameter targetapoasis is 80000.
parameter direction is 90.

lock steering to heading(direction,90).
print "starting ...".
stage.
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

lock steering to heading(direction, 90 - 0.001 * ship:apoapsis).
wait until 0.001 * ship:apoapsis > 85 or ship:apoapsis > targetapoasis.
lock steering to heading(direction, 5).
wait until ship:apoapsis > targetapoasis.
lock throttle to 0.

wait until eta:apoapsis < 10.
lock throttle to (10 - eta:apoapsis) * 0.2.
lock steering to heading(direction, max(0, 10 - eta:apoapsis)).

wait until ship:status = "ORBITING" and ship:periapsis > targetapoasis.
print "ship is " + ship:status + " around " + orbit:body:name.