# SC_AUDITPOWER

`SC_AUDITPOWER.ps1` es un script en PowerShell diseñado para auditar información relacionada con el uso de energía y actividad reciente del sistema operativo Windows 11. Su propósito es facilitar el monitoreo de aspectos clave del equipo, como el tipo de apagado más reciente, el tiempo encendido y los ciclos de carga de la batería.

---

## 🧠 ¿Qué hace el script?

Este script realiza consultas al sistema operativo para obtener los siguientes datos:

- 🖥️ **Nombre del equipo (hostname)**
- ⏰ **Fecha y hora actual**
- 🔌 **Hora del último apagado** (evento `1074`)
- 🛑 **Tipo de arranque** más reciente:
  - Inicio normal
  - Apagado limpio
  - Apagado inesperado (por error eléctrico)
  - Inicio rápido (Fast Startup)
- ⚙️ **Tiempo encendido** (desde el último arranque completo)
- 🔋 **Ciclos de carga de batería** (si el sistema los reporta)

---

## 📤 Exportación de resultados

El script guarda todos los datos anteriores en un archivo `.csv` en el Escritorio del usuario actual. El archivo se nombra automáticamente según el equipo:


> Por ejemplo: `Battery-LAPTOP123.csv`

---

## ✅ Requisitos

- Windows 11
- PowerShell 5.1 o superior (incluido por defecto en Windows 10 y 11)
- Permisos de usuario estándar (no requiere administrador)

> **No requiere módulos externos ni conexión a Internet.**

---

## 🛠️ Cómo usarlo

1. Guarda el script como `SC_AUDITPOWER.ps1`.
2. Haz clic derecho y selecciona **"Ejecutar con PowerShell"**  
   O bien, abre PowerShell y ejecútalo directamente:

```powershell
powershell -ExecutionPolicy Bypass -File .\SC_AUDITPOWER.ps1
```

3. Revisa el archivo .csv generado en tu Escritorio.


## 🛠️ Cómo crear el ejecutable

1. Se debe guardar el script en la ruta deseada.

> Por ejemplo: `C:\Users\nombre\Desktop\SC_AUDITPOWER.ps1`


2. Posteriormente a esto, se debe abrir una terminal de Powershell con privilegios de administrador.

3. Luego se activará la ejecución temporal en Powershell:

```powershell
powershell -ExecutionPolicy Bypass -NoExit
```

4. Se instalará el módulo que crea el archivo .csv en escritorio

```powershell
Import-Module ps2exe -Force
```

5. Se genera el ejecutable en la ruta deseada:

```powershell
Invoke-PS2EXE -InputFile "C:\Users\nombre\Desktop\SC_AUDITPOWER.ps1" -OutputFile "C:\Users\nombre\Desktop\SC_AUDITPOWER.exe" -noConsole

```
El archivo SC_AUDITPOWER.exe aparecerá en el escritorio, listo para usar en cualquier computador con Windows 10 o superior.

## 💡 Notas adicionales
Si el equipo tiene activado el Inicio Rápido, es posible que el tiempo encendido muestre valores prolongados (el sistema no se reinicia completamente en ese modo).

Para obtener datos más precisos, puedes desactivar el inicio rápido desde:

Panel de control → Opciones de energía → Elegir el comportamiento del botón de inicio/apagado → Cambiar configuración no disponible actualmente → Desmarcar “Activar inicio rápido”
