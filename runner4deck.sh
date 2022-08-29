#! /bin/bash
VERSION=0.1

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# NOMBRE DEL PROYECTO: R4D (Runner for Deck)
# VERSION
# ABOUT: script con objetivo de crear accesos rápidos a los juegos de distintas plataformas, es decir, busca en varias ubicaciones dependiendo del plugin
#        y pregunta sobre los juegos a crear acceso directo. También lo añadirá a Steam para que sea más rápido todo el proceso
#
# PARÁMETRO: No tiene.
#
# REQUISITOS: No tiene más allá de los requeridos por el proyecto global.
#
# EXITs:
# 0 --> Salida correcta.
# 1 --> Necesitas revisar el comando.
# 2 --> El plugin no hace bien su trabajo.
# 3 --> El usuario ha querido salir voluntariamente.
##############################################################################################################################################################

#
# VARIABLES DE ENTORNO
#
DIRECTORIO="$HOME/runner4deck/"
DPLUGIN="$DIRECTORIO"plugins/
DGAMES="$DIRECTORIO"games/
DBIN="$DIRECTORIO"bin/


#
# FUNCIONES PARA EL DESARROLLO DE LA APLICACION
#

# Función para todas las comprobaciones iniciales
function checkInicial() {
    [ ! -d "$DIRECTORIO" ] && echo "No existe el directorio principal." && ERROR=SI
    [ ! -d "$DPLUGIN" ] && echo "No existe el directorio de plugins." && ERROR=SI
    [ ! -d "$DGAMES" ] && echo "No existe el directorio de games." && ERROR=SI
    [ ! -d "$DBIN" ] && echo "No existe el directorio de ejectuables." && ERROR=SI

    if [ -n "$ERROR" ];then
        zenity --error \
            --title="runner4deck v$VERSION" \
            --width=250 \
            --text="El plugin no ha devuelto ningun valor esperado."
        exit 1
    fi
}

# Función de bienvenida
function bienVenida() {
    zenity --info \
       --title="runner4deck v$VERSION" \
       --width=250 \
       --text="Bienvenido a runner4deck.\nPrograma para crear accesos rapidos a nuestros juegos favoritos.\n\nEl asistente se mostrara a continuacion. Siga las instrucciones."
}

# Función para seleccionar el plugin a ejecutar
function seleccionaPlugin() {
    PLUG="$DPLUGIN*.plugin"
    
    lista=()
    for i in $PLUG;do
        lista+=(FALSE "$(basename "$i")" "$(sed -n 4p "$i"|tr -d '#')")
    done

    PLUGIN=$(zenity  --title="runner4deck v$VERSION" --list --radiolist --width=1000 --height=300 \
            --text="Selecciona el plugin adecuado para elegir el juego deseado." \
			--column="Select?"  \
			--column="PLUGIN" \
            --column="Descripcion" \
			"${lista[@]}")

    if [ -z "$PLUGIN" ];then
        echo "No se selecciono ningun plugin. Saliendo"
        exit 3
    fi
}

# Función para seleccionar el proton de toda la lista de protones que tiene el usuario
function menuProton() {
    # Devolverá en una variable llamada RETURN el proton elegido. Si se cancela o no existen será null
    listaa=""
    while IFS= read -r -d $'\0'; do
        listaa+="$REPLY|"
    done < <(find "$HOME/.local/share/Steam/compatibilitytools.d/" -name "proton" -print0)
    while IFS= read -r -d $'\0'; do
        listaa+="$REPLY|"
    done < <(find "$HOME/.local/share/Steam/steamapps/common/" -name "proton" -print0)

    protones="${listaa%?}"


    if [ "$protones" == "" ]; then
        echo "No hay protones"
    else
        
        PROTON=$(zenity --title="runner4deck v$VERSION" --forms  --width=1000 --height=300 \
                --text="Valores de Proton" \
                --add-combo="Seleccione Proton:" --combo-values="$protones")

        if [ -z "$PROTON" ]; then
            echo -ne "Se ha cancelado la eleccion de proton.\nSalimos."
            exit 1
        fi
    fi

}
#function menuProton() {
    # Devolverá en una variable llamada RETURN el proton elegido. Si se cancela o no existen sera null
#    lista=()
#    while IFS= read -r -d $'\0'; do
#        lista+=(FALSE "$REPLY")
#    done < <(find "$HOME/.local/share/Steam/compatibilitytools.d/" -name "proton" -print0)
#    while IFS= read -r -d $'\0'; do
#        lista+=(FALSE "$REPLY")
#    done < <(find "$HOME/.local/share/Steam/steamapps/common/" -name "proton" -print0)

#    if [ ${#lista[@]} -eq 0 ]; then
#        echo "No hay protones"
#    else
#        PROTON=$(zenity --title="runner4deck v$VERSION" --list --radiolist --width=1000 --height=300 \
#                --text="Elija el proton que se ajuste a sus necesidades. El juego se ejecutara con este proton." \
#                --column="Select?"  \
#                --column="PROTON" \
#                "${lista[@]}")

#        if [ -z "$PROTON" ]; then
#            echo -ne "Se ha cancelado la eleccion de proton.\nSalimos."
#            exit 1
#        fi
#    fi
#
#}

# Función para seleccionar los flags o banderas para nuestro programa que se ejecuta en proton
function menuFlags() {
    lista=()
    
    num=$(dirname "$PROTON" | grep GE -c)
    if [ ! "$num" -eq 0 ];then
        lista+=(TRUE "DXVK_ASYNC=1" "Sincronizacion asincrona. Mejora el rendimiento, pero pueden banearle en multijugador.")
    fi

    lista+=(TRUE "LANG=es_ES.UTF-8" "Idioma en Espanol. Se utilizara este locale.")
    lista+=(TRUE "gamemoderun" "Modo juego.")
    
    num="$(find /run/media -mindepth 1 -maxdepth 1 -type d | wc -l )"
    if [ ! "$num" -eq 0 ];then
        if [ "$num" -eq 1 ];then
            num=$(find /run/media -mindepth 1 -maxdepth 1 -type d)
            lista+=(TRUE "STEAM_COMPAT_MOUNTS=$num" "Montar ubicacion como unidad.")
        else
            echo "Varias unidades montadas"
            lista2=()
            while IFS= read -r -d $'\0'; do
                lista2+=(FALSE "$REPLY")
            done < <(find /run/media -mindepth 1 -maxdepth 1 -type d -print0)

            num=
            num=$(zenity --title="runner4deck v$VERSION" --list --radiolist --width=1000 --height=300 \
                    --text="Selecciona el directorio para montar la unidad en el juego. Es decir, la microsd." \
                    --column="Select?" \
                    --column="Directorio para mostrar la unidad" \
                    "${lista2[@]}")
            
            if [ "$num" != "" ]; then
                lista+=(TRUE "STEAM_COMPAT_MOUNTS=$num" "Montar ubicacion como unidad.")
            fi
        fi
    fi

    num=$(zenity --title="runner4deck v$VERSION" --list --checklist --width=1000 --height=300 \
            --text="Selecciona las variables/flags para correr el juego." \
            --column="Select?" \
            --column="FLAG" \
            --column="Descripcion" \
            "${lista[@]}")
    
    FLAGS=$(echo "$num" | tr '|' ' ')
}

# Función para mostrar los valores que tenemos y esperar la confirmación del usuario
function mostrarConfirmar() {
    texto="A continuacion, se muestran los valores escogidos:\n\nNombre: $NAMEF\nEjecutable: $EXE\nProton: $PROTON\n\
FLAGS: $FLAGS\n\n\nSeguro que quieres usar estos valores y continuar?"
    zenity --question \
        --title="runner4deck v$VERSION" --width=1000 --height=300 \
        --ok-label="Continuar" \
        --cancel-label="Salir" \
        --text="${texto}"
    ans=$?
    if [ ! $ans -eq 0 ]
    then
        echo "No quiere continuar. Salimos" && exit 3
    fi
}

# Función para pediro el nombre de archivo de salida .runner
function pedirNombre() {
    if [ -z "$NAMEF" ];then
        NAMEF=$(zenity --entry \
                --title="runner4deck v$VERSION" --width=1000 --height=300 \
                --ok-label="Aceptar" \
                --text="Nombre del fichero/acceso directo: ")
    fi

    #Si el nombre de fichero no tiene extensión .runner, se le añade
    echo "$NAMEF" |grep .runner >/dev/null
    ans=$?
    if [ ! "$ans" -eq 0 ];then 
        NAMEF=$NAMEF".runner"
    fi

    NAME="$DGAMES""$NAMEF"
}

# Función para pedir el nombre de archivo de salida .runner
function guardarRunner() {
    echo -ne "#! /bin/bash\n\n# VARIABLES RUNNER\nexport PROTON=\"$PROTON\"\nexport EXE=\"$EXE\"\n\
export ID=\"$ID\"\n\n# RESTO DE VARIABLES\n" | tee "$NAME"
    
    for i in $FLAGS;do
        echo "export $i" | tee -a "$NAME"
    done

    if [ -n "$SIPROTON" ];then
        echo -ne "\nsource $DBIN""runner.sh\n\nexit 0" | tee -a "$NAME"
    else
        echo -ne "\neval \$EXE\n\nexit 0" | tee -a "$NAME"
    fi

    chmod +x "$NAME"
}

# Función para comprobar que se ha creado el fichero y despedirse
function checkBye() {
    if [ -f "$NAME" ];then
        zenity --info \
            --title="runner4deck v$VERSION" \
            --width=250 \
            --text="Fichero creado correctamente.\nGracias por usar este programa.\n\nSaludos."
    else
        zenity --error \
            --title="runner4deck v$VERSION" \
            --width=250 \
            --text="No se ha podido crear el fichero."
        exit 1
    fi
}

# Función como postdata para abrir o no Steam Rom Manager
function abrirSRM() {
    texto="Quieres abrir Steam Rom Manager?"
    
    zenity --question \
        --title="runner4deck v$VERSION" \
        --width=250 \
        --ok-label="Abrir SRM" \
        --cancel-label="Salir" \
        --text="${texto}"
    
    ans=$?
    if [ $ans -eq 0 ]; then
        flatpak run com.steamgriddb.steam-rom-manager
    fi
}
##########################################################################################
# MAIN - PRINCIPAL
##########################################################################################

# Mostramos nombre de programa y versión
echo "runner4deck vers. $VERSION"
bienVenida

# Paso 0 --> Chequeamos todos los parámetros iniciales
checkInicial

# Paso 1 --> listar los plugins y seleccionar uno
echo "Seleccionando plugin."
seleccionaPlugin
# En la variable PLUGIN tenemos el plugin a ejecutar

# Paso 2 --> ejecutar ese plugin, le damos el control
# shellcheck source=/dev/null
source "$DPLUGIN$PLUGIN"
if [ -z "$EXE" ];then
    echo "El plugin no ha devuelto un ejecutable. Salimos"
    zenity --error \
       --title="runner4deck v$VERSION" \
       --width=250 \
       --text="El plugin no ha devuelto ningun valor esperado."
    exit 2
fi
# Tenemos en la variable EXE el ejecutable.
# Si es necesario, también se rellenan otras variables: PROTON, ID, ..

# Paso 3 --> Si el plugin definió que es necesario un Proton, se pregunta por él
if [ -n "$SIPROTON" ];then
    echo "Seleccionando proton."
    menuProton
    # En la variable PROTON tenemos el proton a elegir

    echo "Seleccionando FLAGS"
    menuFlags
    # En la variable FLAGS tenemos las variables a usar
fi

# Paso 4 --> Si no se ha seleccionado nombre anteriormente, se pide
pedirNombre

# Paso 5 --> Muestra valores y espera confirmación
mostrarConfirmar

# Paso 6 --> Guardamos el acceso directo
guardarRunner

# Paso 7 --> Chequeo final y despedida
checkBye

# Paso 8 --> Postdata, quieres arrancar Steam Rom Manager
abrirSRM

exit 0