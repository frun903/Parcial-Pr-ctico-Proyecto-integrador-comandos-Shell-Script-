#!/bin/bash

#Declaro los Colores
COLOR_ROJO='\e[1;31m'
COLOR_VERDE='\e[1;32m'
COLOR_AZUL='\e[1;34m'
COLOR_AMA='\e[1;33m'

#Declaro la negrita
COLOR_RESET="\e[0m"


#Declaro donde esta el errores.log
LOGFILE="errores.log"


# --------------------------------------------------------------------------------------------
# Función: log_error
# Recive el mensae de error y lo graba usando el comando date fecha/hora en errores.log creado previamente.
#  uso eñ comando date para tener la fecha en: YYYY-MM-DD HH:MM:SS
# --------------------------------------------------------------------------------------------------------------------------------
log_error(){
    local mensaje="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: $mensaje" >> "$LOGFILE"
}








# --------------------------------------------------------------------------------------------------------------------------------------
# Función: listar_directorio_actual
# Esta funcion tiene 4 opciones 
# Listar directorio actual en linea
# Listar directorio actual y ocultos
# Listar directorio actual en arbol
# Listar directorio actual en lista 
# ---------------------------------------------------------------------------------------------------------------------------------------

listar_directorio_actual(){
    clear
    while true; do
        
        echo -e "${COLOR_AMA}--Ingrese Opciones Para listar el directorio Actual!--${COLOR_RESET}"
        echo "1) Listar contenido (sin ocultos)"
        echo "2) Listar con archivos ocultos"
        echo "3) Listar en formato árbol"
        echo "4) Listar en formato largo (y con permisos)"
        echo "5) Volver"
        echo "Selecione una opcion 1 a 5: "
        read opciones

        case $opciones in 
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
            5) echo -e "${COLOR_VERDE}Regresando...${COLOR_RESET}"; sleep 1.5 ;break ;;
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
     clear
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
            echo -e "${COLOR_AMA}-- Listar en '$ruta' --${COLOR_RESET}"
            echo "1) Listar contenido (sin ocultos)"
            echo "2) Listar con archivos ocultos"
            echo "3) Listar en formato árbol"
            echo "4) Listar en formato largo (permisos)"
            echo "5) Volver"
            echo "Selecione una opcion 1 a 5: "
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
menu_Borrar(){
  clear
  echo -e "${COLOR_AZUL}-- ¿Cómo deseas borrar? --${COLOR_RESET}"
  echo "1) Con confirmación antes de borrar"
  echo "2) Sin confirmación (borra todo sin preguntar)"
  echo "3) Volver"
  echo "Elige opcion 0 a 3: "
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


#----------------------Creacion de Directorios-----------------------------------------------------------------------
#Como la creacion de la funcion de borrar se complejizo, decidimos hacer todo el crear direcotiorio en una sola funcion

crear_directorio(){
    clear
    # Selecciono  la ruta ruta base ---
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
        echo "Seleccione opcion del 1 al 5:" 
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


  clear
  cowthink -f tux "Hola Soy Linux"
  sleep 1.5
  clear
  cowthink -f tux "Te acompañare en este proyecto"  
  sleep 1.5
  clear
  cowthink -f tux "Comencemos"  

# Menu principal 
while true; do

  echo -e "${COLOR_AMA}Ingrese Opciones!${COLOR_RESET}"
  read opciones

  case $opciones in 
    1) listar_directorio_actual ;;
    2) listar_directorioXdireccion ;;
    3) menu_Borrar ;;
    4) crear_directorio;;
    5) echo -e "${COLOR_VERDE}Terminando Ejecucion";cowsay -f dragon "GRACIAS"; sleep 3; clear; break ;;
    *) echo -e "${COLOR_ROJO}Opción no válida, repita!$" ;;
  esac

done
