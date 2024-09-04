#Crear carpetas código phyton

import os
import shutil

#CREAR las carpetas
ruta = "Indica la ruta donde quieres crear las carpetas"
nombreInicio = "Indica el nombre con el primer consecutivo"
nombreFin = "Indica el nombre con el último consecutivo consecutivo"


# Crea las carpetas
for i in range(nombreInicio, nombreFin + 1):
    rutaCarpeta = os.path.join(ruta, str(i))
    if not os.path.exists(rutaCarpeta):
        os.makedirs(rutaCarpeta)
        print(f"Carpeta '{rutaCarpeta}' creada.")
    else:
        print(f"La carpeta '{rutaCarpeta}' ya existe.")

# COPIAR archivos
rutaArchivo = "Indica la ruta del archivo que quieres copiar masivamente"
rutaInicio = "Indica la ruta donde están las carpetas a las que les quieres copiar el archivo"

# Copia el archivo a las carpetas
for i in range(nombreInicio, nombreFin + 1):
    rutaCarpeta = os.path.join(rutaInicio, str(i))
    if os.path.exists(rutaCarpeta):
        shutil.copy(rutaArchivo, rutaCarpeta)
        print(f"Archivo copiado a '{rutaCarpeta}'.")
    else:
        print(f"La carpeta '{rutaCarpeta}' no existe.")

# Agregar Texto no consecutivo (en mi caso los expedientes siempre comienzan en 0 terminan en 00)
os.chdir('"Indica la ruta donde están las carpetas que quieres agregar digitos en su nombre"')

# Define el rango de nombres consecutivos de carpetas
nombreInicio = "Indica el nombre con el primer consecutivo"
nombreFin = "Indica el nombre con el último consecutivo consecutivo"
digitosParaAgregar = "Indica el dígito a agregar"

# Obtiene todas las carpetas en el directorio actual
carpetas = [f for f in os.listdir('.') if os.path.isdir(f)]

# Filtra y renombra las carpetas dentro del rango especificado
for carpeta in carpetas:
    nombre = int(carpeta)
    if nombreInicio <= nombre <= nombreFin:
        nuevoNombre = digitosParaAgregar + carpeta + digitosParaAgregar + digitosParaAgregar
        os.rename(carpeta, nuevoNombre)