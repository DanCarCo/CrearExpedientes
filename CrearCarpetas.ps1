# Rutas y archivos
$rutaBase = "Indica la ruta del archivo que quieres copiar masivamente"
$archivos = @(
    "archivo 1",
    "archivo 2",
    "archivo 3"
) #Indica el nombre de los archivos que quieres copiar

# Rangos de carpetas
$rangos = @(
    @{Inicio = "Indica el nombre con el primer consecutivo"; Fin = "Indica el nombre con el primer consecutivo"},
)

# Crear carpetas, subcarpetas, y sus subcarpetas
foreach ($rango in $rangos) {
    for ($i = $rango.Inicio; $i -le $rango.Fin; $i++) {
        $rutaCarpeta = Join-Path -Path $rutaBase -ChildPath ($i)
        if (!(Test-Path -Path $rutaCarpeta)) {
            # Crear la carpeta principal
            New-Item -ItemType Directory -Path $rutaCarpeta
            Write-Host "Carpeta '$rutaCarpeta' creada."
            
            # Crear una subcarpeta ("Indica el nombre de la subcarpeta que quieres crear dentro de cada expediente")
            $rutaSubCarpeta = Join-Path -Path $rutaCarpeta -ChildPath "subcarpeta 1"
            New-Item -ItemType Directory -Path $rutaSubCarpeta
            Write-Host "Subcarpeta '"subcarpeta 1"' creada en '$rutaCarpeta'."
            
            # Crear subcarpetas "C01" y "C02" dentro de "subcarpeta 1"
            $rutaC01 = Join-Path -Path $rutaSubCarpeta -ChildPath "C01"
            $rutaC02 = Join-Path -Path $rutaSubCarpeta -ChildPath "C02"
            
            New-Item -ItemType Directory -Path $rutaC01
            New-Item -ItemType Directory -Path $rutaC02
            
            Write-Host "Subcarpetas 'C01' y 'C02' creadas en '$rutaSubCarpeta'."
        } else {
            Write-Host "La carpeta '$rutaCarpeta' ya existe."
        }
    }
}

# Copiar archivos a las carpetas "C01"
$nombreInicio = "Indica el nombre con el primer consecutivo" 
$nombreFin = "Indica el nombre con el primer consecutivo"

for ($i = $nombreInicio; $i -le $nombreFin; $i++) {
    $rutaCarpeta = Join-Path -Path $rutaBase -ChildPath ($i)
    $rutaC01 = Join-Path -Path $rutaCarpeta -ChildPath "subcarpeta 1\C01"
    if (Test-Path -Path $rutaC01) {
        foreach ($archivo in $archivos) {
            $rutaArchivo = Join-Path -Path $rutaBase -ChildPath $archivo
            Copy-Item -Path $rutaArchivo -Destination $rutaC01
            Write-Host "Archivo '$archivo' copiado a '$rutaC01'."
        }
    } else {
        Write-Host "La carpeta '$rutaC01' no existe."
    }
}

# Renombrar carpetas con un "0" antes y después del nombre
Set-Location -Path $rutaBase

$digitosParaAgregar = "0"

# Filtra y renombra las carpetas dentro del rango especificado
$carpetas = Get-ChildItem -Directory
foreach ($carpeta in $carpetas) {
    if ($carpeta.Name -ge $nombreInicio -and $carpeta.Name -le $nombreFin) {
        $nuevoNombre = $digitosParaAgregar + $carpeta.Name + $digitosParaAgregar + $digitosParaAgregar
        Rename-Item $carpeta.FullName -NewName $nuevoNombre
        Write-Host "Carpeta '$carpeta.Name' renombrada a '$nuevoNombre'."
    }
}
