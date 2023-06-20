### Description
POC on getting real time updates on Scada / PLC / HMI 

### Notes
Also, I'm converting the vbs script to python so it can be more maintainable in the future

### Example curl

### Scheduled job (windows)
To run a Python script every minute on the 30th second on a Windows machine, you can use the Windows Task Scheduler. Here's how you can set it up:

1. Open the Task Scheduler by pressing the Windows key, typing "Task Scheduler," and selecting the "Task Scheduler" app.
2. In the Task Scheduler, click on "Create Basic Task" in the "Actions" panel on the right.
3. Provide a name and optional description for the task, then click "Next."
4. Select "Daily" as the trigger, and click "Next."
5. Set the start date and time to the current date and time, then click "Next."
6. Choose "Start a program" as the action, and click "Next."
7. In the "Program/script" field, enter the path to the Python executable. For example, it might be `C:\Python\Python39\python.exe`. If you're not sure, you can check the location of your Python installation.
8. In the "Add arguments" field, enter the path to your Python script file. For example, if your script is located at `C:\path\to\script.py`, you would enter that.
9. Click "Next" to review the task settings.
10. Finally, click "Finish" to create the task.

The task is now scheduled to run every day at the specified start time. However, we need to modify it to run every minute on the 30th second. Here's how you can adjust the task:

1. In the Task Scheduler, locate the task you just created in the list.
2. Right-click on the task and select "Properties."
3. In the "Properties" window, go to the "Triggers" tab.
4. Select the trigger for the task and click "Edit."
5. Change the "Recur every" option to "1 minute(s)".
6. In the "Advanced settings" section, check the box for "Repeat task every" and set it to "1 minute(s)".
7. Under the "Advanced settings," change the "Delay task for" to "30 seconds".
8. Click "OK" to save the changes.

With these modifications, the task will run every minute, but it will be delayed by 30 seconds, so it effectively runs on the 30th second of each minute.

Make sure your Python script contains the desired functionality to execute at that interval, in this case, obtaining the current datetime and the minute after.

Please note that these instructions are based on Windows 10. The steps might vary slightly if you are using a different version of Windows.