'#######Simulation of Startup Sequence#########
Sub StartupSequence
    'Declaration local tags
        Dim Startup				'Startup variable (Binary)
        Dim Shutdown			'Startup variable (Binary)		
        Dim CurrentStep			'Counter for Current Step (unsigned 8-bit)
        Dim StepCounter			'Counter for delay (unsigned 8-bit)
        Dim StartArchive		'value to start achiving (binary)	
        Dim StopArchive			'value to stop achiving (binary)	
        
    'binding internal tags to local tags
        Set Startup     	 = HMIRuntime.Tags("Startup")
        Set Shutdown    	 = HMIRuntime.Tags("Shutdown")
        Set CurrentStep 	 = HMIRuntime.Tags("CurrentStep")
        Set StepCounter  	 = HMIRuntime.Tags("StepCounter")
        Set StartArchive 	 = HMIRuntime.Tags("StartArchive")
        Set StopArchive  	 = HMIRuntime.Tags("StopArchive")
        
    'Read Tag Startup 
    Startup.Read
    
    'Startup Program
    If Startup.Value = 1 Then
        StepCounter.Read
        StartArchive.Write 1
        StopArchive.Write 0 
    'Control current StepCounter
        If StepCounter.Value <17 Then
                StepCounter.Write StepCounter.Value + 1
                'Activate Step 1
                If StepCounter.Value = 3 Then
                    CurrentStep.Write 1
                End If
                'Activate Step 2
                If StepCounter.Value = 8 Then
                    CurrentStep.Write 2
                End If	
                'Activate Step 3
                If StepCounter.Value = 12 Then
                    CurrentStep.Write 3
                End If	
                'Activate Step 4
                If StepCounter.Value = 15 Then
                    CurrentStep.Write 4
                End If
                'Activate Step 5
                If StepCounter.Value = 17 Then
                    CurrentStep.Write 5
                    Startup.Write 0
                End If	
                
            End If
    End If
    End Sub
    
    
    
    '#######Simulation of Shutdown Sequence#########
    Sub ShutdownSequence
    'Declaration local tags
        Dim Startup				'Startup variable (Binary)
        Dim Shutdown			'Startup variable (Binary)		
        Dim CurrentStep			'Counter for Current Step (unsigned 8-bit)
        Dim StepCounter			'Counter for delay (unsigned 8-bit)
        Dim StartArchive		'value to start achiving (binary)	
        Dim StopArchive			'value to stop achiving (binary)
        Dim DateTimeLastStop	'last stop time
    
    'binding internal tags to local tags
        Set Startup     	 = HMIRuntime.Tags("Startup")
        Set Shutdown    	 = HMIRuntime.Tags("Shutdown")
        Set CurrentStep  	 = HMIRuntime.Tags("CurrentStep")
        Set StepCounter  	 = HMIRuntime.Tags("StepCounter")
        Set StartArchive 	 = HMIRuntime.Tags("StartArchive")
        Set StopArchive  	 = HMIRuntime.Tags("StopArchive")
        Set DateTimeLastStop = HMIRuntime.Tags("DateTimeLastStop")
        
    'Read tag Shutdown 
    Shutdown.Read
    
    'Shutdown Program
    If Shutdown.Value = 1 Then
        StepCounter.Read
    
    'Control current StepCounter
        If StepCounter.Value >=17 Then
            StepCounter.Write StepCounter.Value + 1
            'End If
            'Activate Step 6
            If StepCounter.Value = 19 Then
                CurrentStep.Write 6
            End If
            'Activate Step 7
            If StepCounter.Value = 21 Then
                CurrentStep.Write 7
            End If	
            'Activate Step 8
            If StepCounter.Value = 23 Then
                CurrentStep.Write 8
            End If	
            'Activate Step 9
            If StepCounter.Value = 26 Then
                CurrentStep.Write 9
            End If
            'Activate Step 10
            If StepCounter.Value = 29 Then
                CurrentStep.Write 10
            End If
            'Activate Step 11
            If StepCounter.Value = 32 Then
                CurrentStep.Write 11
            End If
            'Activate Step 12
            If StepCounter.Value = 35 Then
                StepCounter.Write 0
                CurrentStep.Write 12
                DateTimeLastStop.Write Now
                Shutdown.Write 0
                StartArchive.Write 0
                StopArchive.Write 1
            End If	
        End If	
    End If
    End Sub
    
    
    '#######Simulation of Stop Sequence#########
    Sub StopSequence
    'Declaration local tags
        Dim Startup				'Startup variable (binary)
        Dim Shutdown			'Startup variable (binary)		
        Dim Stop_End			'Stop value (binary)		
        Dim CurrentStep			'Counter for Current Step (unsigned 8-bit)
        Dim StepCounter			'Counter for delay (unsigned 8-bit)
        Dim StartArchive		'value to start achiving (binary)
        Dim StopArchive			'value to stop achiving (binary)
        Dim DateTimeLastStop	'last stop time
        
    'binding internal tags to local tags
        Set Startup      	 = HMIRuntime.Tags("Startup")
        Set Shutdown     	 = HMIRuntime.Tags("Shutdown")
        Set Stop_End     	 = HMIRuntime.Tags("Stop")
        Set CurrentStep  	 = HMIRuntime.Tags("CurrentStep")
        Set StepCounter  	 = HMIRuntime.Tags("StepCounter")
        Set StartArchive 	 = HMIRuntime.Tags("StartArchive")
        Set StopArchive  	 = HMIRuntime.Tags("StopArchive")
        Set DateTimeLastStop = HMIRuntime.Tags("DateTimeLastStop")
    
    'Read Tag Stop_End 
        Stop_End.Read
    'Controll Stop Status
        If Stop_End.Value = 1 Then
            StepCounter.Write 0
            DateTimeLastStop.Write Now
            CurrentStep.Write 0
            StartArchive.Write 0
            StopArchive.Write 1
            Startup.Write 0
            Shutdown.Write 0
            Stop_End.Write 0
        End If
    End Sub
    