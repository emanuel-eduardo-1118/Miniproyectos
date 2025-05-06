[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# Agregar tipo de Microsoft.VisualBasic
Add-Type -AssemblyName Microsoft.VisualBasic
function noexiste {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $abc,
        [string] $message = "La ruta no existe"
    )
    if (-not (Test-Path -path $abc)) {
        [System.Windows.Forms.MessageBox]::Show($message, ":(")
        return
    }
}
function create_folder {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $rute, 
        [Parameter()]
        [string] $folder_list
    )
    noexiste -abc $rute 
    noexiste -abc $folder_list -message "La ruta de la lista no existe"
    $num_folder = 0
    $error_create = $false
    foreach ($list in Get-Content -path $folder_list) {
        try {
            if (-not (Test-Path -path $rute/$list)) {
                New-Item -path "$rute\$($list.trim())" -ItemType Directory -ErrorAction Stop
                $num_folder++
            }
            else {
                Write-Output Carpetas ya existen
            }
        }
        catch {
            $error_create = $true
        }   
    }

    #comprobar si se crearon correctamente 
    if ($error_create) {
        [System.Windows.Forms.MessageBox]::Show("No se pudo crear correctamente las carpetas, :(")
    }
    else {
        [System.Windows.Forms.MessageBox]::Show("Se crearon correctamente $num_folder carpetas", ":)")
    }
}

function create_sub_folder {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $rute,
        [Parameter()]
        [int]
        $num_subfolder
    )
    $sub_folder_name = @()
    $error_create = $false
    noexiste -abc $rute
    if ($num_subfolder -lt 1) {
        [System.Windows.Forms.MessageBox]::Show("El numero tiene que ser mayor o igual a 1, :/")
        return 
    }
    else {
        for ($i = 0; $i -lt $num_subfolder; $i++) {
            $sub_folder_name += [Microsoft.VisualBasic.Interaction]::InputBox("Ingresa el nombre de la $($i+1) carpeta:", "Crear subcarpetas")
        }
    }
    foreach ($f in Get-ChildItem -path "$rute") {
        for ($i = 0; $i -lt $num_subfolder; $i++) {
            try {
                if (-not (Test-Path -Path "$rute/$f/$($sub_folder_name[$i])")) {
                    New-Item -Path "$rute/$f/$($sub_folder_name[$i])" -ItemType Directory
                    #[System.Windows.Forms.MessageBox]::Show($sub_folder_name[$i],"ruta: $f")
                }
                else {
                    $error_create = $true
                }
            }
            catch {
                $error_create = $true
            }
        }
    }
    if ($error_create) {
        [System.Windows.Forms.MessageBox]::Show("No se pudieron crear las subcarpetas", ":/")
    }
    else {
        [System.Windows.Forms.MessageBox]::Show("Sub carpetas creadas con exito", ":)")
    }
}
while ($true) {
    $choose = [Microsoft.VisualBasic.Interaction]::InputBox("Ingresa 1 para crear carpetas y 2 para crear subcarpetas", "By: Emanuel Eduardo", "")
    if ($choose -eq "1") {
        $rute = [Microsoft.VisualBasic.Interaction]::InputBox("Ingresa la ruta donde crear carpetas:", "Crear carpetas", "")
        $list = [Microsoft.VisualBasic.Interaction]::InputBox("Ingresa la ruta de la lista de carpetas:", "Lista de carpetas", "")
        $list = $list -replace '"', ''
        create_folder -rute $rute -folder_list $list
    }
    else {
        $rute = [Microsoft.VisualBasic.Interaction]::InputBox("Ingresa la ruta donde crear carpetas:", "Crear carpetas", "")
        $num = [Microsoft.VisualBasic.Interaction]::InputBox("Ingresa el numero de subcarpetas a crearse:", "Numero de subcarpetas", "")
        $number = [int]$num
        create_sub_folder -rute $rute -num_subfolder $number
    }
    
}



