Option Explicit
Function action

'Start Script for Startup Sequence
	StartupSequence
'Start Script for Shutdown Sequence
	ShutdownSequence
'Start Script for Shutdown Sequence
	StopSequence
	
'Start Control for Actuators
	ControlActuators
End Function