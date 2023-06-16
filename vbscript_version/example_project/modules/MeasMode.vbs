'########Function which calculates the Measure Mode for Pressure in Tanks and Conductivity Parameter##############


    Function MeasMode(CurrentStep, UpStep, ProductionStep, DownStep, StopStep)

        'Mode 0 = no Funktion,  Standard Measure Mode
            If CurrentStep = 0 Then
                MeasMode = 0 
            End If
        'Mode 1 = Up
            If CurrentStep >= UpStep And CurrentStep <= ProductionStep Then
                MeasMode = 1
            End If
        'Mode 2 = Down
            If CurrentStep >= DownStep And CurrentStep < StopStep Then
                MeasMode = 2
            End If
        'Mode 3 = Stopped	
            If CurrentStep > StopStep Then
                MeasMode = 3
            End If
        'Mode 4 = Production
            If CurrentStep >= ProductionStep And CurrentStep < DownStep Then
                MeasMode = 4
            End If
            
        End Function