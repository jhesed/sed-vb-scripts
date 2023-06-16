Option Explicit
Function action

'Declaration function variables
Dim CurrentStep
Dim UpStep
Dim ProductionStep
Dim DownStep
Dim StopStep

Dim StartValue
Dim Stepsize
Dim EndValue
Dim InitValue

'binding internal variable CurrentStep to script variable
Set CurrentStep = HMIRuntime.Tags("CurrentStep")
'Read Status of CurrentStep
CurrentStep.Read

'##################################################################################
'FI100 in m3/h, FI100_Flow_Rawwater - Zufluss Rohwasser
Dim FI100
Dim FI100_Mode

Set FI100 = HMIRuntime.Tags("FI100_FlowRawwater")
FI100.Read

UpStep 			= 3	
ProductionStep  = 5
DownStep		= 6 
StopStep		= 8
FI100_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 60
StepSize		= 9
EndValue		= 150
InitValue		= 0
FI100.Value = Measurement(FI100.Value, StartValue, StepSize, EndValue, InitValue, FI100_Mode)
FI100.Write

'######################################################################################
'FI101 in m3/h, FI101_FlowConcentrate - Zufluss Konzentrat
Dim FI101
Dim FI101_Mode


Set FI101 = HMIRuntime.Tags("FI101_FlowConcentrate")
FI101.Read

UpStep 			= 5	
ProductionStep  = 5
DownStep		= 7
StopStep		= 7
FI101_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 10
StepSize		= 7
EndValue		= 120
InitValue		= 0

FI101.Value = Measurement(FI101.Value, StartValue, StepSize, EndValue, InitValue, FI101_Mode)
FI101.Write

'#########################################################################################
'FI300 in dm3/h, FI300_FlowCO2 - Zufluss CO2
Dim FI300
Dim FI300_Mode

Set FI300 = HMIRuntime.Tags("FI300_FlowCO2")
FI300.Read


UpStep 			= 4	
ProductionStep  = 5
DownStep		= 7
StopStep		= 7
FI300_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 1
StepSize		= 2
EndValue		= 19
InitValue		= 0

FI300.Value = Measurement(FI300.Value, StartValue, StepSize, EndValue, InitValue, FI300_Mode)
FI300.Write

'#########################################################################################
'FI500 in dm3/h, FI500_FlowChemicals - Zufluss Chemikalien
Dim FI500
Dim FI500_Mode

Set FI500 = HMIRuntime.Tags("FI500_FlowChemicals")
FI500.Read


UpStep 			= 4	
ProductionStep  = 5
DownStep		= 7 
StopStep		= 7 
FI500_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 1
StepSize		= 1.5
EndValue		= 11
InitValue		= 0
FI500.Value = Measurement(FI500.Value, StartValue, StepSize, EndValue, InitValue, FI500_Mode)
FI500.Write

'#########################################################################################
'FI102 in m3/h, FI102_FlowSupplyWater - Zufluss Versorgungswasser/Prozesswasser
Dim FI102
Dim V701

Set FI102 = HMIRuntime.Tags("FI102_FlowSupplyWater")
Set V701 = HMIRuntime.Tags("V701_ValvePermeatIn")
FI102.Read
V701.Read

FI102.Value = FI100.Value - FI101.Value + (FI300.Value/1000) + (FI500.Value/1000)
FI102.Write

If V701.Value = 1 Then
	FI102.Write 10
End If

'#########################################################################################
'QI900 in us/cm, QI900_ConductivityPermeatIn - Leifähigkeit einfließendes Permeat Chemikalien
Dim QI900
Dim QI900_Mode

Set QI900 = HMIRuntime.Tags("QI900_ConductivityPermeatIn")
QI900.Read


UpStep 			= 5
ProductionStep  = 5
DownStep		= 6
StopStep		= 7 
QI900_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 1556
StepSize		= 33
EndValue		= 1310
InitValue		= 1511
QI900.Value = Measurement(QI900.Value, StartValue, StepSize, EndValue, InitValue, QI900_Mode)
QI900.Write

'#########################################################################################
'QI901 in us/cm, QI901_ConductivityConcentrate - Leifähigkeit Concentrat
Dim QI901
Dim QI901_Mode

Set QI901 = HMIRuntime.Tags("QI901_ConductivityConcentrate")
QI901.Read

UpStep 			= 2	
ProductionStep  = 5
DownStep		= 8
StopStep		= 12
QI901_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 2000
StepSize		= 56
EndValue		= 1300
InitValue		= 1900
QI901.Value = Measurement(QI901.Value, StartValue, StepSize, EndValue, InitValue, QI901_Mode)
QI901.Write

'#########################################################################################
'PI200 in bar, PI200_Tank pressure sensor 1 - Drucksensor 1 im Tank
Dim PI200
Dim PI200_Mode

Set PI200 = HMIRuntime.Tags("PI200_Tank")
PI200.Read

UpStep 			= 3	
ProductionStep  = 5
DownStep		= 6
StopStep		= 11
PI200_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 1.1
StepSize		= 0.35
EndValue		= 5.5
InitValue		= 0

PI200.Value = Measurement(PI200.Value, StartValue, StepSize, EndValue, InitValue, PI200_Mode)
PI200.Write

'#########################################################################################
'PI201 in bar, PI201_Tank pressure sensor 1 - Drucksensor 1 im Tank
Dim PI201
Dim PI201_Mode

Set PI201 = HMIRuntime.Tags("PI201_Tank")
PI201.Read

UpStep 			= 3	
ProductionStep  = 5
DownStep		= 6
StopStep		= 11
PI201_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 1.1
StepSize		= 0.32
EndValue		= 5.4
InitValue		= 0

PI201.Value = Measurement(PI201.Value, StartValue, StepSize, EndValue, InitValue, PI201_Mode)
PI201.Write

'#########################################################################################
'PI202 in bar, PI202_Tank pressure sensor 3 - Drucksensor 3 im Tank
Dim PI202
Dim PI202_Mode

Set PI202 = HMIRuntime.Tags("PI202_Tank")
PI202.Read

UpStep 			= 3	
ProductionStep  = 5
DownStep		= 6
StopStep		= 11
PI202_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 1.1
StepSize		= 0.31
EndValue		= 5.3
InitValue		= 0

PI202.Value = Measurement(PI202.Value, StartValue, StepSize, EndValue, InitValue, PI202_Mode)
PI202.Write

'#########################################################################################
'PI203 in bar, PI203_Tank pressure sensor 4 - Drucksensor 4 im Tank
Dim PI203
Dim PI203_Mode

Set PI203 = HMIRuntime.Tags("PI203_Tank")
PI203.Read

UpStep 			= 3	
ProductionStep  = 5
DownStep		= 6
StopStep		= 11
PI203_Mode = MeasMode(CurrentStep.Value, UpStep, ProductionStep, DownStep, StopStep)

StartValue		= 1.1
StepSize		= 0.30
EndValue		= 5.2
InitValue		= 0

PI203.Value = Measurement(PI203.Value, StartValue, StepSize, EndValue, InitValue, PI203_Mode)
PI203.Write


End Function