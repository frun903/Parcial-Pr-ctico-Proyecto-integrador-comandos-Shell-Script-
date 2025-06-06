#!/bin/bash

#Declaro los Colores
COLOR_ROJO="\e[1;31m"
COLOR_VERDE="\e[1;32m"

#Declaro la negrita
COLOR_RESET="\e[0m"


# --------------------------------------------------------------------------------------------------------------------------------------
# Función: listar_directorio_actual
# ---------------------------------------------------------------------------------------------------------------------------------------
# Esta funcion tiene 4 opciones 
# Listar directorio actual en linea
# Listar directorio actual y ocultos
# Listar directorio actual en arbol
# Listar directorio actual en lista 
listar_directorio_actual(){
    clear
    while true; do
        
        echo -e "${COLOR_ROJO}Ingrese Opciones Para listar el directorio Actual!${COLOR_RESET}"
        echo "1) Listar contenido (sin ocultos)"
        echo "2) Listar con archivos ocultos"
        echo "3) Listar en formato árbol"
        echo "4) Listar en formato largo (y con permisos)"
        echo "5) Volver"
        echo "Selecione una opcion 1 a 5: "
        read opciones

        case $opciones in 
            1) ls;;
            2) ls -a ;;
            3) tree ;;
            4) ls -l;;
            5) echo  echo -e "${COLOR_VERDE}Regresando...${COLOR_RESET}"; sleep 1 ;break ;;
            *) echo "Opción no válida, Reintente" ;break;
        esac

       echo "ENTER para continuar..." 
       read dummy
       clear
    done
}





# ------------------------------------------------------------------------------------------------------------------------
# Función: listar_directorio_por_ruta
# ------------------------------------------------------------------------------------------------------------------------
# Esta funcion tiene las mismas 4 opciones que el anterior pero en este caso el usuario debe poner la direcccion
# Listar directorio actual en linea
# Listar directorio actual y ocultos
# Listar directorio actual en arbol
# Listar directorio actual en lista 

listar_directorioXdireccion(){
     clear
      echo "Ingrese la ruta del directorio (ENTER = actual): ${COLOR_RESET}" 
      read ruta
     ruta=${ruta:-.}
      #ruta de ejemplo /home/frang/Escritorio/D&D

      #Manejjo de errores preliminae quiero hacer un ounto log
      if [[ ! -d "$ruta" ]]; then
          echo -e "${COLOR_ROJO}Error: '$ruta' no es un directorio valido.${COLOR_RESET}"
          echo "ENTER para volver..." 
          read dummy
          return
      fi

      while true; do
            echo -e "${COLOR_ROJO}-- Listar en '$ruta' --${COLOR_RESET}"
            echo "1) Listar contenido (sin ocultos)"
            echo "2) Listar con archivos ocultos"
            echo "3) Listar en formato árbol"
            echo "4) Listar en formato largo (permisos)"
            echo "5) Volver"
            read -p "Seleccione una opción [1-5]: " opcion2

            case $opcion2 in 
                1) ls "$ruta" ;;
                2) ls -a "$ruta" ;;
                3) tree "$ruta" ;;
                4) ls -l "$ruta" ;;
                5) 
                    echo -e "${COLOR_VERDE}Regresando...${COLOR_RESET}"
                    sleep 0.5
                    break
                    ;;
                *) echo -e "${COLOR_ROJO}Opción no válida.${COLOR_RESET}" ;;
            esac

            echo
            read -p "ENTER para continuar..." dummy
            clear
      done
}




# Menu principal 
while true; do
  clear
  echo -e "${COLOR_ROJO}Ingrese Opciones!${COLOR_RESET}"
  read opciones

  case $opciones in 
    1) listar_directorio_actual ;;
    2) listar_directorioXdireccion ;;
    3) echo "Punto 2" ;;
    4) echo "Punto 3";;
    5) echo -e "${COLOR_ROJO}Terminando Ejecucion"; break ;;
    *) echo -e "${COLOR_ROJO}Opción no válida, repita!$" ;;
  esac

done
