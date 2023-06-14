'#######Simulation of Step Activitiy Actuators#########

Sub ControlActuators

    'Declaration local tags
        Dim CurrentStep 'Counter for current Step
        Dim V700 'V700_ValveRawwater (Binary)
        Dim V701 'V701_ValvePermeatIn (Binary)
        Dim V702 'V702_ValvePermeatOut (Binary)
        Dim V703 'V703_ValveConcentrate (Binary)
        Dim V704 'V704_ValveCO2 (Binary)
        Dim V705 'V705_ValveChemicals (Binary)
        Dim V706 'V706_ValveGully (Binary)
        Dim P800 'P800_PumpRawwater
    
    'binding internal tags to local tags
        Set CurrentStep = HMIRuntime.Tags("CurrentStep")
        Set V700 = HMIRuntime.Tags("V700_ValveRawwater")
        Set V701 = HMIRuntime.Tags("V701_ValvePermeatIn")
        Set V702 = HMIRuntime.Tags("V702_ValvePermeatOut")
        Set V703 = HMIRuntime.Tags("V703_ValveConcentrate")
        Set V704 = HMIRuntime.Tags("V704_ValveCO2")
        Set V705 = HMIRuntime.Tags("V705_ValveChemicals")
        Set V706 = HMIRuntime.Tags("V706_ValveGully")
        Set P800 = HMIRuntime.Tags("P800_PumpRawwater")
    
    '#######START PROGRAMM#####################################
    'Read current Status
        CurrentStep.Read
    
    'Startup , Delay means Delay after Klick on Startup
    'Step1:  Open Outlet-Valve V706 -> Delay 3s
        If CurrentStep.Value = 1 Then
            V703.Write 1
            V706.Write 1
        End If
    'Step2:  Open Inlet-Valve V700 -> Delay 8s
        If CurrentStep.Value = 2 Then
            V700.Write 1
        End If
    'Step3:  Start Pump P800 -> Delay 12s
        If CurrentStep.Value = 3 Then
            P800.Write 1
        End If
    'Step4:  Start dosing C02 and chemicals - Open V704 and V705 -> Delay 15s
        If CurrentStep.Value = 4 Then
            V704.Write 1
            V705.Write 1
        End If
    'Step5:  Open Output-Valve V702 ->Delay 17s
        If CurrentStep.Value = 5 Then
            V702.Write 1
        End If
    
    
    'Shutdown, Delay means Delay after Klick on Startup
    'Step6:  Close Outlet-Valve V702 -> Delay 19s
        If CurrentStep.Value = 6 Then
            V702.Write 0
        End If
    'Step7:  Stop dosing C02 - Close V704 and V705 -> Delay 21s
        If CurrentStep.Value = 7 Then
            V704.Write 0
            V705.Write 0
        End If
    'Step8:  Stop P800 -> Delay 23s
        If CurrentStep.Value = 8 Then
            P800.Write 0
        End If
    'Step9:  Close Inlet-Valve V700 -> Delay 26s
        If CurrentStep.Value = 9 Then
            V700.Write 0
        End If
    'Step10:  Open Valve V701 -> Delay 29s
        If CurrentStep.Value = 10 Then
            V701.Write 1  
            V703.Write 1
        End If
    'Step11: Close Inlet-Valve V701 -> Delay 32s
        If CurrentStep.Value = 11 Then
            V701.Write 0 
            V703.Write 0
        End If
    'Step12: Close OutletValve V706 -> Delay 35s
        If CurrentStep.Value = 12 Then
            V706.Write 0
        End If
        
    'Stop
    'Step0:  Close all Valves V700 - V706 and deactivate Pump P800
        If CurrentStep.Value = 0 Then
            V700.Write 0
            V701.Write 0
            V702.Write 0
            V703.Write 0
            V704.Write 0
            V705.Write 0	
            V706.Write 0
            P800.Write 0
        End If
    End S