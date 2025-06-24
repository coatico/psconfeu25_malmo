Measure-Command{
$bigFileName = "plc_log.txt";$plcNames = @('PLC_A','PLC_B','PLC_C','PLC_D');$errorTypes = @('Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning');$statusCodes = @('OK','WARN','ERR');$logLines = [string[]]::new(50000)

# Get base time once and calculate ticks for ultra-fast timestamp generation
$baseTime = Get-Date
$baseTicks = $baseTime.Ticks
$oneSecondTicks = 10000000L
# Use single .NET Random instance for maximum speed
$rnd = [System.Random]::new()
# Pre-calculate all timestamps for maximum speed
$timestamps = [string[]]::new(50000)
for ($i = 0; $i -lt 50000; $i++) {$timestamps[$i] = [DateTime]::new($baseTicks - ($i * $oneSecondTicks)).ToString("yyyy-MM-dd HH:mm:ss")}

# Hyper-optimized loop using direct array access and minimal operations
for ($i = 0; $i -lt 50000; $i++) { 
    $plcId = $rnd.Next(4)
    $operator = $rnd.Next(101, 121)
    $batch = $rnd.Next(1000, 1101)
    $statusId = $rnd.Next(3)
    $temp = [math]::Round($rnd.Next(60,110) + $rnd.NextDouble(), 2)
    $load = $rnd.Next(101)
    $isErrorValue = ($rnd.Next(8) -eq 3)
    
    # Direct array access for maximum speed
    $ts = $timestamps[$i]
    $plc = $plcNames[$plcId]
    $status = $statusCodes[$statusId]
    
    if ($isErrorValue) {
        $errorTypeId = $rnd.Next(4)
        if ($errorTypeId -eq 0) {
            $errorVal = $rnd.Next(1, 11)
            $logLines[$i] = "ERROR; $ts; $plc; Sandextrator overload; $errorVal; $status; $operator; $batch; $temp; $load"
        } else {
            $errorType = $errorTypes[$errorTypeId]
            $logLines[$i] = "ERROR; $ts; $plc; $errorType; ; $status; $operator; $batch; $temp; $load"
        }
    } else {
        $logLines[$i] = "INFO; $ts; $plc; System running normally; ; $status; $operator; $batch; $temp; $load"
    }
}
# Use fastest file writing method
[System.IO.File]::WriteAllLines($bigFileName, $logLines);Write-Output "PLC log file generated."
}
