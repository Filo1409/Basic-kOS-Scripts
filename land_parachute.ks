lock steering to srfRetrograde.

set tostage to true.

when tostage then {
    if (ship:stagenum = 1) {
        return false.
    }

    wait until stage:ready.
    print "staging ...".
    stage.
}

WHEN (NOT CHUTESSAFE) THEN {
    CHUTESSAFE ON.
    RETURN (NOT CHUTES).
}

wait until ship:status = "LANDED" or ship:status = "SPLASHED".
print "ship is " + ship:status + " on " + orbit:body:name.