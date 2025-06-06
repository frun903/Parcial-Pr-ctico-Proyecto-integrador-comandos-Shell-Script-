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
4.  Manejo de errores

>[!TIPS] Para los colores se utilizo de referencia: https://soloconlinux.org.es/colores-en-bash/ 

## 1. Listar directorios
Para el Listado directorios se penso en implementar dos funciones en base a donde se encuentre el usuario, la primera funcion que se implemento fue __listar_directorio_actual()__ lista y muestra por terminal los elementos del dirctorio donde se encuentre el usuario actualmente, y __listar_directorioXdireccion()__ por medio de una ruta solicitida por el usuario se listan los elementos del directorio indicado por la ruta. Ambas funciones tienen los mismo incisos o tipos de muestra
- Listar contenido (sin ocultos)
- Listar con archivos ocultos
- Listar en formato árbol
- Listar en formato largo (permisos)

El manejo de errores se mostrar adecuadamente en el insiso 4 de manejo de errores.


## 3.Borrar directorios


## 4.Manejo de Errores

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

