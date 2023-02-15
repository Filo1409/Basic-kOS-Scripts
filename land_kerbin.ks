wait until periapsis < 0.

lock steering to srfRetrograde.

set tostage to true.

when tostage then {
    wait until stage:ready.
    print "staging ...".
    stage.

    if (ship:stagenum = 1) {
        return false.
    } else {
        return true.
    }
}

WHEN (NOT CHUTESSAFE) THEN {
    CHUTESSAFE ON.
    RETURN (NOT CHUTES).
}

wait until ship:status = "LANDED" or ship:status = "SPLASHED".
print "ship is " + ship:status + " on " + orbit:body:name.