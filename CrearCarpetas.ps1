#CREAR las carpetas


$ruta = "Indica la ruta donde quieres crear las carpetas"
$nombreInicio = "Indica el nombre con el primer consecutivo"
$nombreFin = "Indica el nombre con el último consecutivo consecutivo"


for ($i = $nombreInicio; $i -le $nombreFin; $i++) {
    $rutaCarpeta = Join-Path -Path $ruta -ChildPath ($i)
    if (!(Test-Path -Path $rutaCarpeta)) {
        New-Item -ItemType Directory -Path $rutaCarpeta
        Write-Host "Carpeta '$rutaCarpeta' creada."
    } else {
        Write-Host "La carpeta '$rutaCarpeta' ya existe."
    }
}



#COPIAR archivos


$rutaArchivo = "Indica la ruta del archivo que quieres copiar masivamente"

$rutaInicio = "Indica la ruta donde están las carpetas a las que les quieres copiar el archivo"
$nombreInicio = "Indica el nombre con el primer consecutivo"
$nombreFin = "Indica el nombre con el último consecutivo consecutivo"


for ($i = $nombreInicio; $i -le $nombreFin; $i++) {
    $rutaCarpeta = Join-Path -Path $rutaInicio -ChildPath ($i)
    if (Test-Path -Path $rutaCarpeta) {
        Copy-Item -Path $rutaArchivo -Destination $rutaCarpeta
        Write-Host "Archivo copiado a '$rutaCarpeta'."
    } else {
        Write-Host "La carpeta '$rutaCarpeta' no existe."
    }
}



#Agregar Texto no consecutivo (en mi caso los expedientes siempre comienzan en 0 terminan en 00)

Set-Location -Path  "Indica la ruta donde están las carpetas que quieres agregar digitos en su nombre"

# Define el rango de nombres consecutivos de carpetas
$nombreInicio = "Indica el nombre con el primer consecutivo"
$nombreFin = "Indica el nombre con el último consecutivo consecutivo"
$digitosParaAgregar = "Indica el dígito a agregar"

# Obtiene todas las carpetas en el directorio actual
$carpetas = Get-ChildItem -Directory

# Filtra y renombra las carpetas dentro del rango especificado
foreach ($carpeta in $carpetas) {
    if ($carpeta.Name -ge $nombreInicio -and $carpeta.Name -le $nombreFin) {
        $nuevoNombre = $digitosParaAgregar + $carpeta.Name + $digitosParaAgregar + $digitosParaAgregar
        Rename-Item $carpeta.FullName -NewName $nuevoNombre
    }
}
