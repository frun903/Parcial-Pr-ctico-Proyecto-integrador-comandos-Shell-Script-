#!/bin/bash

COLOR_ROJO="\e[1;31m"
COLOR_RESET="\e[0m"

# Listar directorio actual en linea
# Listar directorio actual y ocultos
# Listar directorio actual en arbol
# Listar directorio actual en lista 
listar_directorio_actual(){
    while true; do
        echo -e "${COLOR_ROJO}Ingrese Opciones Para listar el directorio Actual!${COLOR_RESET}"
        echo "1) Listar directorio actual"
        echo "2) Listar directorio actual y archivos ocultos"
        echo "3) Listar directorios y subdirectorios en formato árbol"
        echo "4) Listar directorios y permisos en lista "
        echo "5) Volver al menu principal"
        read opciones

        case $opciones in 
            1) ls ;;
            2) ls -a ;;
            3) tree ;;
            4) ls -l;;
            5) echo "Saliendo..."; break ;;
            *) echo "Opción no válida, Reintente" ;break;
        esac
    done
}


listar_directorioXdireccion(){
    echo -e "Ingrese direccion"

}



# Listar Directorio

# Listar directorio actual ()
# Listar directorio actual y ocultos
# Listar directorio actual en arbol
while true; do
  echo -e "${COLOR_ROJO}Ingrese Opciones!${COLOR_RESET}"
  read opciones

  case $opciones in 
    1) listar_directorio_actual ;;
    2) echo "Listado por direccion";;
    3) echo "Punto 2" ;;
    4) echo "Punto 3";;
    5) echo -e "${COLOR_ROJO}Terminando Ejecucion"; break ;;
    *) echo -e "${COLOR_ROJO}Opción no válida, repita!$" ;;
  esac

done
