#!/bin/bash

#Declaro los Colores    
COLOR_ROJO='\e[1;31m'        # Rojo basico
COLOR_VERDE='\e[1;32m'       #Verde comun   
COLOR_AZUL='\e[1;34m'       #este axul resulto muy opaco
COLOR_AMA='\e[1;33m'        #Amarillo
COLOR_CYAN='\e[1;36m'      # Celeste 
COLOR_MAGENTA='\e[1;35m'   # Magenta o fucsia
COLOR_GRIS='\e[1;90m'      # Gris claro 


#Declaro la negrita
COLOR_RESET="\e[0m"


#Declaro donde esta el errores.log
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #ests linea es clave ya que redireccciona el error 
LOGFILE="$SCRIPT_DIR/errores.log"



# --------------------------------------------------------------------------------------------
# Función: log_error
# Recive el mensae de error y lo graba usando el comando date fecha/hora en errores.log creado previamente.
#  uso eñ comando date para tener la fecha en: YYYY-MM-DD HH:MM:SS
# --------------------------------------------------------------------------------------------------------------------------------
log_error(){
    local mensaje="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: $mensaje" >> "$LOGFILE"
}


#------------------------------------------------------------------------------------------------------
#Funcion: ver_errores.log
#Esta funcion hace CAT para los elementos de log creados c/d ves que ocurre un error
ver_errores(){
    echo -e "${COLOR_AMA}--¡Registro de Errores!--${COLOR_RESET}"
    
    if [[ -s "$LOGFILE" ]]; then      # -s => el archivo existe y no está vacío
        cat "$LOGFILE"
    else
        echo -e "${COLOR_VERDE}No hay errores registrados por ahora. ¡Todo bien!${COLOR_RESET}"
    fi
    
    echo "ENTER para continuar..."
    read dummy
}






# --------------------------------------------------------------------------------------------------------------------------------------
# Función: listar_directorio_actual
# Esta funcion tiene 4 opciones 
# Listar directorio actual en linea
# Listar directorio actual y ocultos
# Listar directorio actual en arbol
# Listar directorio actual en lista 
# Listar solamente directorios 
# ---------------------------------------------------------------------------------------------------------------------------------------

listar_directorio_actual(){
    while true; do
        clear
        linux_talk "Listar Directorios!"
        echo -e "${COLOR_AMA}--Ingrese Opciones Para listar el directorio Actual!--${COLOR_RESET}"
        echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
        echo "0) Navegacion"
        echo "1) Listar todo contenido (sin ocultos)"
        echo "2) Listar todo contenido con archivos ocultos"
        echo "3) Listar todo el contendio en formato árbol"
        echo "4) Listar todo el contenido en formato largo (y con permisos)"
        echo "5) Listar solamente directorios (sin archivos regulares) --Funes--"
        echo "6) Volver"
        echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
        echo -e "${COLOR_MAGENTA}>> Elige opcion [0-6]: ${COLOR_RESET}"
        read opciones

        case $opciones in 
            0)  navegacion
               continue;;
            
            1)  ls 2> /dev/null || {
                    log_error "Fallo al listar (ls) en directorio actual: $(pwd)"
                    echo -e "${COLOR_ROJO}Error al listar el directorio actual.${COLOR_RESET}"
                } ;;
            2)  ls -a 2> /dev/null || {
                    log_error "Fallo al listar con ocultos (ls -a) en dir actual: $(pwd)"
                    echo -e "${COLOR_ROJO}Error al listar con archivos ocultos."
                } ;;
            3)  tree 2> /dev/null || {
                    log_error "Fallo al listar en árbol (tree) en dir actual: $(pwd)"
                    echo -e "${COLOR_ROJO}Error al mostrar árbol."
                }
                ;;
            4) ls -l 2> /dev/null || {
                    log_error "Fallo al listar en formato largo (ls -l) en dir actual: $(pwd)"
                    echo -e "${COLOR_ROJO}Error al listar en formato largo."
                };;
            5)  
                echo -e "${COLOR_AMA}Directorios disponibles ${COLOR_RESET}"
                find . -maxdepth 1 -type d -printf '%f/\n' 2>/dev/null | grep -vE '^\.\/?$' ;;


            6) echo -e "${COLOR_VERDE}Regresando...${COLOR_RESET}"; sleep 1.5 ;break ;;
            *) echo "Opción no válida, Reintente" ;break;
        esac

       echo "ENTER para continuar..." 
       read dummy
       clear
    done
}





# ------------------------------------------------------------------------------------------------------------------------
# Función: listar_directorio_por_ruta
# Esta funcion tiene las mismas 4 opciones que el anterior pero en este caso el usuario debe poner la direcccion
# Listar directorio actual en linea
# Listar directorio actual y ocultos
# Listar directorio actual en arbol
# Listar directorio actual en lista 
# ------------------------------------------------------------------------------------------------------------------------

listar_directorioXdireccion(){
     
      echo -e "${COLOR_AZUL}Ingrese la ruta del directorio (ENTER = actual): ${COLOR_RESET}" 
      read ruta
     ruta=${ruta:-.}
      #ruta de ejemplo /home/frang/Escritorio/D&D

      #Manejjo de errores preliminae quiero hacer un ounto log
      if [[ ! -d "$ruta" ]]; then
          log_error "Directorio no existe para listar_directorioXdireccion(): '$ruta'"  
          echo -e "${COLOR_ROJO}Error: '$ruta' no es un directorio valido."
          echo "ENTER para volver..." 
          read dummy
          return
      fi

      while true; do
            clear
            linux_talk "Direcotorios por ruta Absoluta"
            echo -e "${COLOR_C}-- Listar en '$ruta' --${COLOR_RESET}"
            echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
            echo "1) Listar todo el contenido (sin ocultos)"
            echo "2) Listar todo el contenido con archivos ocultos"
            echo "3) Listar todo el contenido en formato árbol"
            echo "4) Listar todo el contenido en formato largo (permisos)"
            echo "5) Listar solo directorios --Funes--"
            echo "6) Volver"
            echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
            echo -e "${COLOR_MAGENTA}>> Elige opcion [1-5]: ${COLOR_RESET}"
            read opcion2

            case $opcion2 in 
                1)  ls "$ruta" 2> /dev/null || {
                        log_error "Fallo al listar (ls) en ruta '$ruta'"
                        echo -e "${COLOR_ROJO}Error al listar '$ruta'.${COLOR_RESET}"
                    } ;;
                
                2) ls -a "$ruta" 2> /dev/null || {
                        log_error "Fallo al listar con ocultos (ls -a) en ruta '$ruta'"
                        echo -e "${COLOR_ROJO}Error al listar con ocultos en '$ruta'.${COLOR_RESET}"
                    };;
                3) tree "$ruta" 2> /dev/null || {
                        log_error "Fallo al listar en árbol (tree) en ruta '$ruta'"
                        echo -e "${COLOR_ROJO}Error al mostrar árbol en '$ruta'. ¿Está instalado 'tree'?${COLOR_RESET}"
                    };;
                4) ls -l "$ruta" 2> /dev/null || {
                        log_error "Fallo al listar en formato largo (ls -l) en ruta '$ruta'"
                        echo -e "${COLOR_ROJO}Error al listar en formato largo '$ruta'.${COLOR_RESET}"
                    };;

                5) 
                    echo -e "${COLOR_AMA}Directorios disponibles ${COLOR_RESET}"
                    find "$ruta" -maxdepth 1 -type d -printf '%f/\n' 2>/dev/null \ | grep -vE '^\.\/?$' ;;

                6) 
                    echo -e "${COLOR_VERDE}Regresando...${COLOR_RESET}"; sleep 1.5; break;;
                *) echo -e "${COLOR_ROJO}Opción no válida.${COLOR_RESET}" ;;
            esac

            echo "ENTER para continuar..."
            read dummy
            clear
      done
}



# ----------------------------------------------------------------------------------------------
# Función: borrar_directorio_confirmacion
# Pide ruta y borra recursivamente con -i, el -i le da una capa de seguridad haciendo
# que por cada directorio (o elemento) el script pregunte "Quieres borrar eso?", te da la oportinidad de cancelar por si no querias borrar algo
# ------------------------------------------------------------------------------------------------
borrar_directorio_confirmacion(){
    clear
    echo "--Ingrese ruta del directorio a borrar: --"
    read dir
    if [[ -z "$dir" ]]; then
        # -z se fija si dir contiene una cadena vacia 
        log_error "Ruta vacia en borrar_directorio_confirmacion()"
        echo -e "${COLOR_ROJO}No ingreso ninguna ruta.${COLOR_RESET}"

    elif [[ ! -d "$dir" ]]; then
        log_error "Directorio inbalido en borrar_directorio_confirmacion(): '$dir'"
        echo -e "${COLOR_ROJO}Error: '$dir' no es un directorio balido.${COLOR_RESET}"
    
    else
        rm -r -i "$dir"
        if [[ $? -eq 0 ]]; then
            echo -e "${COLOR_VERDE}Directorio borrado: '$dir'.${COLOR_RESET}"
            sleep 1.5
        else
            log_error "Fallo al borrar '$dir' con (rm -r -i)"
            echo -e "${COLOR_ROJO}Error al borrar el directorio '$dir'.${COLOR_RESET}"
        fi
    fi
    echo "ENTER para continuar..."
    read dummy
}

# ----------------------------------------------------------------------------------------------
# Función: borrar_directorio_confirmacion
# Pide ruta y borra recursivamente con -f, el -f borrara todo recursivamente sin preguntar
# ------------------------------------------------------------------------------------------------

borrar_directorio_SIN_confirmacion(){
    clear
    echo -e "${COLOR_ROJO}-- ATENCION ESTA FUNCION ELIMINARIO EL DIRECTORIO INDICADO SIN CONFIRMACION --${COLOR_RESET}"
    echo -e "${COLOR_AMA}--Ingrese ruta del directorio a borrar: --${COLOR_RESET}"
    read dir
    if [[ -z "$dir" ]]; then
        # -z se fija si dir contiene una cadena vacia 
        log_error "Ruta vacia en borrar_directorio_SIN_confirmacion()"
        echo -e "${COLOR_ROJO}No ingreso ninguna ruta.${COLOR_RESET}"

    elif [[ ! -d "$dir" ]]; then
        log_error "Directorio inbalido en borrar_directorio_SIN_confirmacion(): '$dir'"
        echo -e "${COLOR_ROJO}Error: '$dir' no es un directorio balido.${COLOR_RESET}"
    
    else
        rm -r -f "$dir" 2> /dev/null #recordemos este ultimo es que para que el error no se muestre x terminal 
        if [[ $? -eq 0 ]]; then
            echo -e "${COLOR_VERDE}Directorio borrado: '$dir'.${COLOR_RESET}"

        else
            log_error "Fallo al borrar '$dir' (rm -r -f)"
            echo -e "${COLOR_ROJO}Error al borrar el directorio '$dir'.${COLOR_RESET}"
        fi
    fi
    echo "ENTER para continuar..."
    read dummy
}

# Direcciones para borra
# /home/frang/Escritorio/D&D_(otra copia)
# /home/frang/Escritorio/D&D_(copia)

# ----------------------------------------------------------------------------------------------
# Función: Menu de Borrar, la verdad se me ocurrio mientras lo hacia 
# ------------------------------------------------------------------------------------------------
menu_Borrar_direccion(){
  clear
  linux_talk "A Borrar!"
    
  echo -e "${COLOR_CYAN}-- ¿Cómo deseas borrar? --${COLOR_RESET}"
  echo "1) Con confirmación antes de borrar"
  echo "2) Sin confirmación (borra todo sin preguntar)"
  echo "3) Volver"
  echo -e "${COLOR_MAGENTA}>> Elige opcion [1-3]: ${COLOR_RESET}"
  read  opt_borrar

  case $opt_borrar in
    1)
      borrar_directorio_confirmacion;;
    2)
      borrar_directorio_SIN_confirmacion;;
    3)
      echo -e "${COLOR_VERDE}Volviendo al menú principal...${COLOR_RESET}";
      sleep 1;;
    *)
      echo -e "${COLOR_ROJO}Opción inbalida. Volviendo...${COLOR_RESET}"; sleep 1;;
  esac

}


# --------------------------------------------------------------------------------
# NUEVO BORRAR
# --------------------------------------------------------------------------------
# Función: borrar_actual_con_confirm
# - Pide al usuario el nombre de un subdirectorio en $PWD
# - Borra recursivamente con -i (pregunta y/n por cada archivo/subcarpeta)
# --------------------------------------------------------------------------------
borrar_actual_con_confirm(){
    echo -e "${COLOR_AZUL}Ingrese nombre de Archivo a borrar (en $(pwd)).${COLOR_RESET}"
    read dir

    if [[ -z "$dir" ]]; then
        log_error "Ruta vacia en borrar_directorio"
        echo -e "${COLOR_ROJO}No ingresaste ningún nombre.${COLOR_RESET}"
        sleep 1.5
        return
    
    elif [[ ! -d "$dir" ]]; then
        log_error "Intento de borrar (con confirm) NO dir válido: '$PWD/$dir'"
        echo -e "${COLOR_ROJO}'$dir' no existe o no es un directorio.${COLOR_RESET}"
        sleep 1.5
        return    
    else
        echo -e "${COLOR_AZUL}Borrado con confirmación de '$dir'...${COLOR_RESET}"
        rm -r -i "$dir"  
        sleep 1.5
        return
   fi

    
   #Menajse post borrar 
    if [[ $? -eq 0 ]]; then
        echo -e "${COLOR_VERDE}Directorio '$dir' borrado correctamente.${COLOR_RESET}"
    else
        log_error "Fallo al borrar con -i: '$PWD/$dir'"
        echo -e "${COLOR_ROJO}No se completó el borrado de '$dir'.${COLOR_RESET}"
    fi

    echo "ENTER para continuar..."
    read dummy
}


# --------------------------------------------------------------------------------
# Función: borrar_actual_sin_confirm
# - Pide al usuario el nombre de un subdirectorio en $PWD
# - Borra recursivamente con -f (sin preguntar)
# --------------------------------------------------------------------------------
borrar_actual_sin_confirm(){
    
    echo -e "${COLOR_AZUL}Ingrese nombre de Archivo a borrar (en $(pwd)).${COLOR_RESET}"
    read dir

    if [[ -z "$dir" ]]; then
        echo -e "${COLOR_ROJO}No ingresaste ningún nombre.${COLOR_RESET}"
        log_error "Usuario no ingreso cadena vacia"
        sleep 1.5
        return
    

    elif [[ ! -d "$dir" ]]; then
        log_error "Intento de borrar (sin confirm) NO dir válido: '$PWD/$dir'"
        echo -e "${COLOR_ROJO}'$dir' no existe o no es un directorio.${COLOR_RESET}"
        sleep 1.5
        return
    else

        echo -e "${COLOR_ROJO}¡PELIGRO! Borrado forzado de '$dir'... ATENCION${COLOR_RESET}"
        rm -r -f "$dir" 2>/dev/null
        sleep 1.5
        return
    fi


    if [[ $? -eq 0 ]]; then
        echo -e "${COLOR_VERDE}Directorio '$dir' eliminado sin confirmacion.${COLOR_RESET}"
    else
        log_error "Fallo al borrar con -f: '$PWD/$dir'"
        echo -e "${COLOR_ROJO}No se completo el borrado de '$dir'.${COLOR_RESET}"
    fi

    echo "ENTER para continuar..."
    read dummy
}


# -------------------------------------------------------------------------------
# Función: rmdir_actual
# Elimina un subdirectorio VACÍO en el directorio actual ($PWD) sin confirmación.
# -------------------------------------------------------------------------------
rmdir_actual(){
    local dir="$1"

    read -p "Nombre del subdirectorio vacío a eliminar (en $(pwd)): " dir
    

    if [[ -z "$dir" ]]; then
        echo -e "${COLOR_ROJO}No ingresaste ningún nombre.${COLOR_RESET}"
         log_error "rmdir_no_confirm: '$dir' no existe o no es un directorio"
         sleep 1.5
         return

    elif [[ ! -d "$dir" ]]; then
        log_error "rmdir_no_confirm: '$dir' no existe o no es un directorio"
        echo -e "${COLOR_ROJO}'$dir' no existe o no es un directorio.${COLOR_RESET}"
        sleep 1.5
        return
    elif [[ -n "$(ls -A "$dir" 2>/dev/null)" ]]; then
        log_error "rmdir_no_confirm: '$dir' no está vacío"
        echo -e "${COLOR_ROJO}'$dir' no está vacío.${COLOR_RESET}"
        sleep 1.5
        return
    else

     # Sin confirmación
        rmdir "$dir" 2>/dev/null

    fi

    if [[ $? -eq 0 ]]; then
        echo -e "${COLOR_VERDE}Directorio '$dir' eliminado sin confirmación.${COLOR_RESET}"
    else
        log_error "rmdir_no_confirm: fallo al eliminar '$dir'"
        echo -e "${COLOR_ROJO}Error al eliminar '$dir'.${COLOR_RESET}"
    fi

    echo "ENTER para continuar..."
    read dummy
}

# Ultimo menu
menu_borrar_directorio_actual(){
    while true; do
        clear
        linux_talk "A borrar!"
        echo -e "${COLOR_CYAN}Borrar sobre Directorio Actual $(pwd)${COLOR_RESET}"
        echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
        echo -e "${COLOR_AMA}0)${COLOR_RESET} Navegacion"
        echo -e "${COLOR_AMA}1)${COLOR_RESET} Listar subdirectorioes en pocision actual"
        echo -e "${COLOR_AMA}2)${COLOR_RESET} Eliminar subdirectorio vacío (rmdir)"
        echo -e "${COLOR_AMA}3)${COLOR_RESET} Borrar directorio con confirmación$"
        echo -e "${COLOR_AMA}4)${COLOR_RESET} Borrar directorio sin confirmación"
        echo -e "${COLOR_AMA}5)${COLOR_RESET} Volver"
        echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
        read -p "$(echo -e ${COLOR_MAGENTA}">> Elige opción [0-5]: "${COLOR_RESET})" opt
  

        case $opt in
            0)
                navegacion
                ;;
            1)
                find . -maxdepth 1 -type d -printf '%f/\n' 2>/dev/null | grep -vE '^\.\/?$'
                echo "enter para continuar..."
                read dummy
                continue 
                ;;
            2)  
                      echo -e "${COLOR_AZUL} Archivos disponibles para eliminiacion ${COLOR_RESET}"
                     find . -maxdepth 1 -type d -printf '%f/\n' 2>/dev/null | grep -vE '^\.\/?$'
                    rmdir_actual
                ;;
            3)  
                    echo -e "${COLOR_AZUL} Archivos disponibles para eliminiacion ${COLOR_RESET}"
                    find . -maxdepth 1 -type d -printf '%f/\n' 2>/dev/null | grep -vE '^\.\/?$'
                 borrar_actual_con_confirm
                ;;
            4)
                echo -e "${COLOR_AZUL} Archivos disponibles para eliminiacion ${COLOR_RESET}"
                find . -maxdepth 1 -type d -printf '%f/\n' 2>/dev/null | grep -vE '^\.\/?$'
                borrar_actual_sin_confirm
                ;;
            5)
                echo -e "${COLOR_VERDE}Regresando...${COLOR_RESET}"
                sleep 1
                break
                ;;
            *)
                echo -e "${COLOR_ROJO}Opción inbalida.${COLOR_RESET}"
                sleep 1
                ;;
        esac
    done
}


#---------------------------------------------------------------------------------------------
# Creacion directorios en directorio actual
#Como la creacion de la funcion de borrar se complejizo, decidimos hacer todo el crear direcotiorio en una sola funcion
#----------------------------------------------------------------------------------------------
crear_directorio(){
  
  #Munu creacion
    while true; do
        clear
        linux_talk "A Crear !"
        AQUI="$(pwd)"
        echo -e "${COLOR_CYAN}Usted esta aqui: $AQUI --${COLOR_RESET}"
        echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
        echo "0) Navegavegacion"
        echo "1) Directorio simple"
        echo "2) Nombre con espacios"
        echo "3) Varios directorios a la vez"
        echo "4) Directorio padre/hijo (-p)"
        echo "5) Listado de directorios disponibles "
        echo "6) Volver"
        echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
        echo -e "${COLOR_MAGENTA}>> Elige opcion [1-5]: ${COLOR_RESET}"
        read opt

        case $opt in
            0) 
               navegacion
               continue;; 

            1)  
                echo "Nombre del directorio: " 
                read nombre
                mkdir "$nombre" 2>/dev/null
                ;;
            
            2)  
                echo "Nombre del directorio con espacios: " 
                read nombre
                mkdir "$nombre" 2>/dev/null
                ;;
            3) 
                echo  "Nombres separos por espacios para guardar multi directorios"
                read multi
                for n in $multi; do
                    mkdir "$n" 2>/dev/null
                done
                ;;
            4)  
                echo "crear directorio por ruta padre/hijo (ejde uso: padre/hijo): " 
                read rutaPH
                mkdir -p "$AQUI/$rutaPH" 2>/dev/null
                ;;
            
            5)  
                echo -e "${COLOR_AMA}Directorios disponibles ${COLOR_RESET}"
                find . -maxdepth 1 -type d -printf '%f/\n' 2>/dev/null | grep -vE '^\.\/?$'
                echo "press enter para continuar"
                read dummy 
                continue
                ;;
            
            6)  
                echo -e "${COLOR_VERDE}Volviendo...${COLOR_RESET}"
                sleep 1.5
                break
                ;;
            *)  
                echo -e "${COLOR_ROJO}Opcion inbalida.${COLOR_RESET}"
                echo -e "${COLOR_ROJO}Volviendo...${COLOR_RESET}"
                sleep 1.5
                continue
                ;;
        esac

        # Manejo de errores
        # $? es la variable que guarda el codigo de salida del último comando en este caso el mkdir
        # es 0 si salio todo bien
        # si es otra cosa hubo error, en el caso de haya error lo guarde con el log error (para esta aplicacion no se guarda que error hubo solo que hubo error es disinto al listar directorio donde si lo hacia)
        if [[ $? -eq 0 ]]; then
            echo -e "${COLOR_VERDE}Directorio(s) creado(s) correctamente en '$ruta'.${COLOR_RESET}"
        else
            log_error "Fallo al crear directorio(s) en crear_directorio(), opcion $opt, en ruta '$ruta'"
            echo -e "${COLOR_ROJO}Error al crear directorio(s). Revisa errores.log.${COLOR_RESET}"
        fi

        echo "ENTER para continuar..."
        read dummy
    done
}



#---------------------------------------------------------------------------------------------
# Creacion de directorios por ruta 
#Como la creacion de la funcion de borrar se complejizo, decidimos hacer todo el crear direcotiorio en una sola funcion
#----------------------------------------------------------------------------------------------

crear_directorio_ruta(){
    linux_talk "A Crear! Escribi bien la ruta!"
    clear
    # Selecciono  la ruta ruta base ---
    linux_talk "A Crear con Ruta Absoluta!"
    echo -e "${COLOR_AMA}Ingrese ruta de creación (ENTER = actual):${COLOR_RESET}"
    read ruta
    ruta=${ruta:-.}

    if [[ ! -d "$ruta" ]]; then
        log_error "Directorio base inbalido en crear_directorio(): '$ruta'"
        echo -e "${COLOR_ROJO}Error: '$ruta' no es un directorio balido.${COLOR_RESET}"
        read -p "ENTER para continuar..." dummy
        return
    fi

  #Munu creacion
    while true; do
        clear
        echo -e "${COLOR_AZUL}-- Crear directorio en: $ruta --${COLOR_RESET}"
        echo "1) Directorio simple"
        echo "2) Nombre con espacios"
        echo "3) Varios directorios a la vez"
        echo "4) Directorio padre/hijo (-p)"
        echo "5) Volver"
        echo -e "${COLOR_MAGENTA}>> Elige opcion [1-5]: ${COLOR_RESET}"
        read opt

        case $opt in
            1)  
                echo "Nombre del directorio: " 
                read nombre
                mkdir "$ruta/$nombre" 2>/dev/null
                ;;
            
            2)  
                echo "Nombre del directorio con espacios: " 
                read nombre
                mkdir "$ruta/$nombre" 2>/dev/null
                ;;
            3) 
                echo  "Nombres separos por espacios para guardar multi directorios"
                read multi
                for n in $multi; do
                    mkdir "$ruta/$n" 2>/dev/null
                done
                ;;
            4)  
                echo "crear directorio por ruta padre/hijo (ejde uso: padre/hijo): " 
                read rutaPH
                mkdir -p "$ruta/$rutaPH" 2>/dev/null
                ;;
            5)  
                echo -e "${COLOR_VERDE}Volviendo...${COLOR_RESET}"
                sleep 1.5
                break
                ;;
            *)  
                echo -e "${COLOR_ROJO}Opcion inbalida.${COLOR_RESET}"
                echo -e "${COLOR_ROJO}Volviendo...${COLOR_RESET}"
                sleep 1.5
                continue
                ;;
        esac

        # Manejo de errores
        # $? es la variable que guarda el codigo de salida del último comando en este caso el mkdir
        # es 0 si salio todo bien
        # si es otra cosa hubo error, en el caso de haya error lo guarde con el log error (para esta aplicacion no se guarda que error hubo solo que hubo error es disinto al listar directorio donde si lo hacia)
        if [[ $? -eq 0 ]]; then
            echo -e "${COLOR_VERDE}Directorio(s) creado(s) correctamente en '$ruta'.${COLOR_RESET}"
        else
            log_error "Fallo al crear directorio(s) en crear_directorio(), opcion $opt, en ruta '$ruta'"
            echo -e "${COLOR_ROJO}Error al crear directorio(s). Revisa errores.log.${COLOR_RESET}"
        fi

        echo "ENTER para continuar..."
        read dummy
    done
}


#----------------------------------------------------------------------------------------------------------------------------------------
# Navegacion a pedido del docente se hace un apartado de navegacion entre directorios. La funcion navegacion permite
# Ver el directorio actual, ir al directorio anterior o uno mas interno. 
navegacion(){
    local opt
    while true; do
        # Actualiza el directorio actual
        
        AQUI="$(pwd)"
        clear
        linux_talk "Navegacion"
        echo -e "${COLOR_CYAN}Usted está en: ${COLOR_RESET}$AQUI"
        echo 
        echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
        echo "Opciones:"
        echo "  0) Seleccionar este directorio"
        echo "  1) Subir al directorio padre"
        echo "  2) Subir 2 niveles hacia atrás"
        echo
        echo " *) Subdirectorios disponibles:"
        find . -maxdepth 1 -type d -printf '%f/\n' 2>/dev/null | grep -vE '^\.\/?$'
        echo
        echo -e "${COLOR_AMA}───────────────────────────────────────────────────────────────────${COLOR_RESET}"
        read -p "Elige [0,1,2 o nombre de subdirectorio]: " opt
        case "$opt" in
            0)
                TARGET_DIR="$AQUI"
                sleep 0.2
                echo -e "${COLOR_VERDE}Regresando...${COLOR_RESET}"
                sleep 1
                break
                ;;
            1)
                cd .. || { echo -e "${COLOR_ROJO}No pude subir.${COLOR_RESET}"; sleep 1; }
                ;;
            2)
                cd ../.. || { echo -e "${COLOR_ROJO}No pude subir dos niveles.${COLOR_RESET}"; sleep 1; }
                ;;
            *)
                if [[ -z "$opt" ]]; then
                    log_error "Opción vacía en navegacion()"
                    echo -e "${COLOR_ROJO}No ingresaste ninguna opción.${COLOR_RESET}"
                elif [[ -d "$opt" ]]; then
                    cd "$opt"
                else
                    log_error "Opción inválida en navegacion(): '$opt'"
                    echo -e "${COLOR_ROJO}“$opt” no es un subdirectorio válido.${COLOR_RESET}"
                fi
                sleep 1
                ;;
        esac
    done
}





#-----------------------------------------------------------------Soy un Pinguino que habla------------------------------------------------


linux_talk(){
    clear
    cowthink -f tux "$1"
    sleep 1.5
}

# Atrapa Ctrl+C esto lo vi del link
trap '
  linux_talk "Se escapa, Atrapenlo"
  sleep 1
  exit 0
' SIGINT


linux_talk "¡Hola, bienvenido al Gestor de Archivos y Directorios!"
sleep 2.5
linux_talk "Este es un Proyecto integrador del equipo Fran Gomez, Tomi Ossana y Santi Planas"
sleep 2.5
linux_talk "¿Listo para comenzar?"
sleep 2.5
clear
AQUI=$(pwd)



#-----------------------------------------------------------------main--------------------------------------------------------------------
while true; do
    linux_talk "¿Qué deseas hacer hoy?"
    echo -e "${COLOR_CYAN} Usted esta: $AQUI ${COLOR_RESET}"
    echo -e "${COLOR_AMA}┌───────────────────────────────────────────────────────────────────┐${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}0)${COLOR_RESET} Navegacion                            ${COLOR_AMA}│${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}1)${COLOR_RESET} Listar directorio actual              ${COLOR_AMA}│${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}2)${COLOR_RESET} Crear en directorio Actual            ${COLOR_AMA}│${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}3)${COLOR_RESET} Borrar en directorio Acutal           ${COLOR_AMA}│${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}4)${COLOR_RESET} Listar por ruta absoluta              ${COLOR_AMA}│${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}5)${COLOR_RESET} Crear directorio por ruta absoluta   ${COLOR_AMA} │${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}6)${COLOR_RESET} Borrar directorio por ruta absoluta   ${COLOR_AMA}│${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}7)${COLOR_RESET} Ver Errores                           ${COLOR_AMA}│${COLOR_RESET}"
    echo -e "${COLOR_AMA}│${COLOR_RESET} ${COLOR_VERDE}8)${COLOR_RESET} Salir                                 ${COLOR_AMA}│${COLOR_RESET}"
    echo -e "${COLOR_AMA}└────────────────────────────────────────────────────────────────────┘${COLOR_RESET}"
    echo -e "${COLOR_MAGENTA}>> Elige opcion [1-8]: ${COLOR_RESET}"
    read opciones

    case $opciones in 
        0)
            
            AQUI=$(pwd)
            linux_talk "Tu estas $AQUI pero vamos a movernos!"
            sleep 0.5
            navegacion
            ;;


        1)
            linux_talk "¡Vamos a listar el directorio actual!"
            listar_directorio_actual
            ;;
        2)
            linux_talk "¡A crear se ha dicho!"
            crear_directorio
            ;;
        3)
            menu_borrar_directorio_actual
            ;;
        4)
            listar_directorioXdireccion
            ;;
        5)  
            crear_directorio_ruta
            ;;
         
        6)
           linux_talk "Vamos a borrar algo... Picaron!"
            menu_Borrar_direccion
            ;;
           
        7)  
            linux_talk "Ahh como la cagaste, recordemos tus errores"
            ver_errores;;
        
        8)  
            linux_talk "¡Vuelve pronto, compañero Linux siempre estara para Ti!!"
            sleep 1
            break
            ;;


        *)  
            
            linux_talk "Opcion Inbalida! No me... Paciencia.."
            ;;
    esac
done