# Proyecto-integrador-comandos-Shell-Script

### Materia:  Sistemas Operativos

### Profesor: Lic. Gustavo A. Funes 

### Alumnos 
- Gomez Francisco 
- Ossana Tomas
- Planas Santiago

### Año: 2025

### Consigna del Grupo
Gestor de directorios
1.  Listar directorios
2.  Crear directorios y subdirectorios pidiendo ingrese o seleccione el directorio desde donde se
crea.
3. Borrar directorios
4.  Manejo de errores y registro de logs
5. Navegacion entre directorios

>[!TIPS] Para los colores se utilizo de referencia: https://soloconlinux.org.es/colores-en-bash/ 

## 1. Listar directorios
Para el Listado directorios se penso en implementar dos funciones en base a donde se encuentre el usuario, la primera funcion que se implemento fue __listar_directorio_actual()__ lista y muestra por terminal los elementos del dirctorio donde se encuentre el usuario actualmente, y __listar_directorioXdireccion()__ por medio de una ruta solicitida por el usuario se listan los elementos del directorio indicado por la ruta. Ambas funciones tienen los mismo incisos o tipos de muestra
- Listar contenido (sin ocultos)
- Listar con archivos ocultos
- Listar en formato árbol
- Listar en formato largo (permisos)
- Listar solo subdirectorios

El manejo de errores se mostrar adecuadamente en el insiso 4 de manejo de errores.

## 2. Creación de Directorios

Se ofrecen dos métodos para crear directorios:

### `crear_directorio()`
Crea directorios dentro de la ruta actual. Opciones disponibles:

- Crear directorio simple.
- Crear directorio con espacios en el nombre.
- Crear múltiples directorios a la vez.
- Crear directorio jerárquico (padre/hijo).
- Mostrar lista de directorios actuales.

### `crear_directorio_ruta()`
Permite seleccionar una ruta absoluta donde crear los directorios. Incluye las mismas opciones y validaciones que la anterior.


## 3.Borrar directorios
En el gestor dispones de tres funciones y un submenu especficos para borrar carpetas:

#### `borrar directorio confirmacion()`
Pide al usuario la ruta de un directorio y lo elimina recursivamente con `rm -r -i`, preguntando **sí/no** por cada archivo o subdirectorio.

  1. Lee `dir` (ruta).  
  2. Si `dir` está vacío o no existe, registra el fallo en `errores.log` y muestra un mensaje de error.  
  3. Si es válido, ejecuta `rm -r -i "$dir"`.  
  4. Registra en el log y muestra un mensaje según el código de salida.  


#### `borrar_directorio_SIN_confirmacion()`
Pide la ruta y la elimina recursivamente con rm -r -f, sin solicitar confirmación.


#### `menu_Borrar()`
Submenú mediante el cual el usuario elige cómo borrar:

- Con confirmación → llama a borrar_directorio_confirmacion()

- Sin confirmación → llama a borrar_directorio_SIN_confirmacion()

- Volver → regresa al menú principal

### Desde ruta absoluta:
- `borrar_directorio_confirmacion()` → Borra recursivamente con `rm -r -i`, solicitando confirmación por cada elemento.
- `borrar_directorio_SIN_confirmacion()` → Borra con `rm -r -f`, sin preguntar.
- `menu_Borrar_direccion()` → Submenú que permite elegir entre ambas opciones.

## 4. Manejo de Errores y Visualización de Errores

Se creo la funcion __log_error()__ que se encarga de tomar un mensaje de error (descripto por nosotros) por argumento y añadirlo a un errores.log de nuestro repositorio. La funcion utiliza internamiente _date_ para guarda la fecha y la hora en la que ocurrio el error.

```bash
# La funcion 
log_error(){
    local mensaje="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: $mensaje" >> "$LOGFILE"
}


# Llamammos la funcion

ls 2> /dev/null || {
    log_error "Fallo al listar (ls) en directorio actual: $(pwd)"
    echo -e "${COLOR_ROJO}Error al listar el directorio actual.${COLOR_RESET}"
}
```
Para el manejo de errores se utilizo el `2> /dev/null` cuando se ejecuta un comando y este genera un error (como permiso denegado) se envia a un canal definido como __descriptor de archivo 2 o stderr__.
El redireccionamiento `2> /dev/null` significa “envia todo lo que se escribiria en stderr al dispositivo nulo”. El `/dev/null` envia allí se descarta sin mostrar nada en pantalla de la terminarl asi __suprimimos cualquier mensaje de error__. Luego con el __operador || conctanemos__ la funcion de guardar el texto de error en __error.log__.

La funcion *log_error* concatenada guarda lo pasado por arguemento (el mensaje de error), ejecuta la funcion internamente y muestra el mensaje que a ocurrido el error luego de esto el codigo vuelve a su ejecucion normal.   

```bash
#fallo en ruta indicada
      if [[ ! -d "$ruta" ]]; then
          log_error "Directorio no existe para listar_directorioXdireccion(): '$ruta'"  
          echo -e "${COLOR_ROJO}Error: '$ruta' no es un directorio valido."
          echo "ENTER para volver..." 
          read dummy
          return
      fi
```
La combinacion `-d "$ruta"` verifica si el valor de la ruta existe combinado con el __!__ me indica _si la ruta no existe haz esto_.

#### Manejo de errores en funciones de borrado

Tanto `borrar_directorio_confirmacion()` como `borrar_directorio_SIN_confirmacion()` incluyen las siguientes comprobaciones y acciones de logging:

**Ruta vacia**  
```bash
if [[ -z "$dir" ]]; then
    log_error "Ruta vacía en <nombre_función>()"
    echo -e "${COLOR_ROJO}No ingresaste ninguna ruta.${COLOR_RESET}"
    return
fi
```

Qw ocurre: si el usuario pulsa ENTER sin escribir nada eso indica el _-z del if_
Accion: se graba un mensaje en errores.log y se muestra un aviso en rojo.

**Directorio inbalido**
```bash
elif [[ ! -d "$dir" ]]; then
    log_error "Directorio inválido en <nombre_función>(): '$dir'"
    echo -e "${COLOR_ROJO}Error: '$dir' no es un directorio válido.${COLOR_RESET}"
    return
fi
```
Si la ruta no existe o no es una carpeta se registra en el log y se informa al usuario, de la misma forma que en el listar directorios

---

###  Visualización del Log de Errores

Se implementó también la función:

#### `ver_errores()`
Muestra el contenido del archivo `errores.log`, si existe. Si está vacío, indica que no se han producido errores.

---

## 5. Navegación entre Directorios

Se creó una función específica a pedido del docente:

### `navegacion()`
Permite al usuario:

- Ver su ubicación actual (`pwd`).
- Subir un nivel (`cd ..`) o dos niveles (`cd ../..`).
- Ingresar a un subdirectorio disponible.

Incluye validaciones, listado de opciones y control de errores por ruta no válida.

---

##  Extras: Pingüino que habla

Cada acción importante del menú se acompaña con un mensaje generado por el comando `cowthink -f tux`. Este detalle lúdico mejora la interacción con el usuario final.

---

##  Menú Principal

El script presenta un menú interactivo con las siguientes opciones:

1. Navegación entre directorios  
2. Listar directorio actual  
3. Crear en directorio actual  
4. Borrar en directorio actual  
5. Listar por ruta absoluta  
6. Crear por ruta absoluta  
7. Borrar por ruta absoluta  
8. Ver errores  
9. Salir  

---

##  Requisitos

- Bash Shell  
- Comando `tree` instalado (`sudo apt install tree`)  
- Comando `cowthink` (parte del paquete `cowsay`)  

---

##  Estructura del Repositorio

- /integrador.sh # Script principal ejecutable
- /errores.log # Archivo de log generado automáticamente
- /README.md # Este archivo de documentación