parameter _altitude, _vector.
print "Starting suborbital observation program".
declare function _run_stage {
    wait until stage:ready.
    print "=> New stage".
    stage.
}

declare function _lock_landing {
    lock steering to lookdirup(up:vector, -velocity:surface).
}

declare _waypoints to allwaypoints().
declare _index to 0.
declare _selection to 0.

// selecting waypoint
print "Please select waypoint from list:".
for wp in _waypoints {
    print _index+": "+wp:name.
    set _index to _index+1.
}
set _selection to terminal:input:getchar().
declare _target to _waypoints[_selection:tonumber(0)].
print "Selected waypoint is:"+_target:name.

// calculating
declare _compass to _target:geoposition:heading.
declare _distance to _target:geoposition:distance.
declare _fixed_height to 2000.
declare _selected_altitude to _altitude - _fixed_height.
declare _base_angle to arctan(_selected_altitude / _distance).
declare _angle to _base_angle.
if _vector = 1 { set _angle to _base_angle*1.15.  } else { set _angle to _base_angle*0.85. }.
print "-----------------------------------".
print "Waypoint altitude is:" + _altitude.
print "Base angle is:" + _base_angle.
print "Distance is:" + _distance + " meters.".
print "Desired angle is:"+_angle.
print "Heading will be compass="+_compass+" with angle="+_angle.
print "-----------------------------------".
print "Please, press any button to proceed sequence....".
set _selection to terminal:input:getchar().
list engines in _engines.
lock steering to up.
print "Launching...".
_run_stage.
print "Waiting for altitude "+_fixed_height.
wait until ship:altitude > _fixed_height.
print "Manevouring...".
lock steering to heading(_compass,_angle).
print "Waiting burnout...".
wait until _engines[0]:flameout.
print "Engine used all fuel. Please hit the button when you a ready.".
set _selection to terminal:input:getchar().
_run_stage.
print "Locking steering to landing vector.".
_lock_landing.
print "Running landing sequence".
_run_stage.
print "Program is complete. If you harmed or died during execution, please call to our support center.".
