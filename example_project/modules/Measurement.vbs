'#############Function to simulate Measurement for different modes#############
    Function Measurement (Value, StartValue, StepSize, EndValue, InitValue, Mode)

        'Declaration local tags
        Dim Max
        Dim Min
        Dim rRnd
        
        'Rounding
        Randomize
        rRnd = Rnd
        
        'binding tag "Value" to tag "Measurement"
        Measurement = Value
        
        'If-Operation to controll StartValue < EndValue
        If StartValue < EndValue Then
            Select Case Mode
                Case 0	'Mode 0 = Exit Funktion
                        Measurement = InitValue
                Case 1	'Mode 1 = UpStep
                    If Measurement < StartValue Then
                        Measurement = StartValue
                    Exit Function
                    End If
                Case 2	'Mode 2 = DownStep
                    If Measurement >= StartValue Then
                        Measurement = Measurement - StepSize
                    End If
                Case 3 	'Mode 3 = StoppedStep
                    Measurement = InitValue			
                Case 4 	'Mode 4 = ProductionStep
                    Min = EndValue - (3*StepSize)
                    Max = EndValue + (StepSize/4)
                
                    If Measurement < Min Then
                        Measurement = Measurement + StepSize
                    End If
                    
                    If Measurement >= Min And Measurement < Max Then
                        Measurement = Measurement + (StepSize/2 * rRnd)
                    End If
                    
                    If Measurement > Max Then
                        Measurement = Measurement - (StepSize/2 * rRnd)
                    End If
            End Select
        End If
        
        'If-Operation to controll StartValue > EndValue
        If StartValue > EndValue Then
            Select Case Mode
                Case 0	'Mode 0 = Exit Funktion
                    Measurement = InitValue		
                Case 1	'Mode 1 = UpStep
                    If Measurement < EndValue Then
                        Measurement = StartValue
                    Exit Function
                    End If
                    
                    If Measurement >= EndValue Then
                        Measurement = Measurement - StepSize
                    End If
                Case 2	'Mode 2 = DownStep
                    If Measurement <= StartValue Then
                        Measurement = Measurement + StepSize
                    End If		
                Case 3 	'Mode 3 = StoppedStep
                    Measurement = InitValue		
                Case 4 	'Mode 4 = ProductionStep
                    Min = EndValue - (StepSize/4)
                    Max = EndValue + (3*StepSize)
                
                    If Measurement > Max Then
                        Measurement = Measurement - StepSize
                    End If
                    
                    If Measurement <= Max And Measurement > Min Then
                        Measurement = Measurement - (StepSize /2 * rRnd)
                    End If
                    
                    If Measurement <  Min Then
                        Measurement = Measurement + (StepSize /2 * rRnd)
                    End If
            End Select
        End If
        
        End Function