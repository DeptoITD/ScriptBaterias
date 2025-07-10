#El siguiente script se encarga de realizar unas consultas al sistema Operativo Windows 11.

#Su función es consultar datos de uso de energía del equipo, entre los que se encuentran:
# *Hora del último apagado
# *Hostname
# *Tiempo en activo de CPU
# *Tipo de último apagado
# Todos estos datos son posteriormente exportados en un archivo .csv

# Obtener hostname del equipo
$ComputerName = $env:COMPUTERNAME

# Obtener ruta del escritorio (compatible con cualquier idioma)
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$CsvFileName = "Battery-$ComputerName.csv"
$CsvPath = Join-Path $DesktopPath $CsvFileName

# Obtener fecha y hora actual
$Now = Get-Date

# Último apagado (evento 1074)
$ShutdownEvent = Get-WinEvent -FilterHashtable @{LogName='System'; Id=1074} -MaxEvents 1
$ShutdownTime = if ($ShutdownEvent) { $ShutdownEvent.TimeCreated } else { "No disponible" }

# Verificar tipo de arranque
$BootEvents = Get-WinEvent -FilterHashtable @{LogName='System'; Id=6005,6006,41,1} -MaxEvents 20 | Sort-Object TimeCreated -Descending
$BootType = "No determinado"

foreach ($event in $BootEvents) {
    switch ($event.Id) {
        6005 { $BootType = "Inicio del sistema (boot normal)"; break }
        6006 { $BootType = "Apagado limpio (shutdown normal)"; break }
        41   { $BootType = "Apagado inesperado o fallo eléctrico"; break }
        1    { $BootType = "Reinicio tras apagado híbrido (inicio rápido)"; break }
    }
}

# Obtener tiempo desde el último arranque
$LastBoot = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$Uptime = $Now - $LastBoot
$UptimeFormatted = "{0:N2} horas" -f $Uptime.TotalHours

# Generar reporte de batería
$BatteryReportPath = "$env:TEMP\battery-report.html"
powercfg /batteryreport /output $BatteryReportPath | Out-Null
Start-Sleep -Seconds 2

# Leer contenido del HTML
$BatteryReportContent = Get-Content $BatteryReportPath -Raw

# Extraer ciclos de carga
$CycleCount = "No disponible"
if ($BatteryReportContent -match "Cycle Count.*?<td.*?>(\d+)<\/td>") {
    $CycleCount = $matches[1]
}

# Crear objeto de datos para adjuntarlos al archivo .csv
$Datos = [PSCustomObject]@{
    "Nombre del equipo"     = $ComputerName
    "Fecha y hora actual"   = $Now
    "Último apagado"        = $ShutdownTime
    "Tipo de arranque"      = $BootType
    "Tiempo encendido"      = $UptimeFormatted
    "Ciclos de carga"       = $CycleCount
}

# Exportar a CSV
$Datos | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8

Write-Host "✅ Reporte generado en: $CsvPath"
