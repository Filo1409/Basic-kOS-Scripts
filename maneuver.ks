wait until nextNode:eta < 60.
lock steering to nextNode:deltav.

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
    if (stage:liquidfuel > 0.1) {
        set tostage to false.
    }

    if (ship:stagenum = 1) {
        return false.
    } else {
        return true.
    }
}

wait until vang(steering, ship:facing:vector) < 1.

lock maxAcc to ship:maxthrust/ship:mass.

wait until nextNode:eta <= 0.
set dv0 to nextNode:deltav.

lock throttle to min(nextNode:deltav:mag/max(maxAcc, 0.000001), 1).

wait until nextNode:deltav:mag < 0.1.
wait until vdot(dv0, nextNode:deltav) < 0.5.
lock throttle to 0.
