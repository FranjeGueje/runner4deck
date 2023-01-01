#! /bin/bash
VERSION=0.3
NOMBRE="runner4deck"

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# LICENSE: GNU General Public License v3.0 (https://raw.githubusercontent.com/FranjeGueje/runner4deck/master/LICENSE)
# NOMBRE DEL PROYECTO: R4D (Runner for Deck)
# ABOUT: script con objetivo de crear accesos rápidos a los juegos de distintas plataformas, es decir, busca en varias ubicaciones dependiendo del plugin
#        y pregunta sobre los juegos a crear acceso directo. También lo añadirá a Steam para que sea más rápido todo el proceso
#
# PARÁMETRO: No tiene.
#
# REQUISITOS: No tiene más allá de los requeridos por el proyecto global.
#
# EXITs:
# 0 --> Salida correcta.
# 1 --> Error: Necesitas revisar el comando.
# 2 --> Error: El plugin no hace bien su trabajo.
# 3 --> El usuario ha querido salir voluntariamente.
# 127 --> Error: no existe el programa zenity y es necesario.
##############################################################################################################################################################

#
# VARIABLES DE ENTORNO
#
CONFIG="$HOME/.config/$NOMBRE.conf"
DIRECTORIO="$HOME/$NOMBRE/"
DPLUGIN="$DIRECTORIO"plugins/
DGAMES="$DIRECTORIO"games/
DBIN="$DIRECTORIO"bin/



#
# FUNCIONES PARA EL DESARROLLO DE LA APLICACION
#


# Función con todas las traducciones
function fLanguage() {

    # establecemos los textos según idioma
    case "$LANG" in
    es_ES.UTF-8)
        lTEXTERRORDIRECTORIO="No existe algún directorio de la aplicación necesario."
        lTEXTBIENVENIDA="Bienvenido a $NOMBRE.\nPrograma para crear accesos rapidos a nuestros juegos favoritos.\n\nEl asistente se mostrara a continuacion. Siga las instrucciones.\n\nLicencia: GNU General Public License v3.0"
        lTEXTELEGIRPLUGIN="Selecciona el plugin adecuado para elegir el juego deseado."
        lTEXTERRORPLUGIN="El plugin no ha devuelto ningun valor esperado."
        lCOLUMNADESC="Descripcion"
        lTEXTPROTONELEGIR="Valores de Proton"
        lCOMBOPROTON="Seleccione un Proton:"
        lDESCDXVK="Sincronizacion asincrona. Mejora el rendimiento, pero pueden banearle en multijugador."
        lDESCLANG="Idioma en Espanol. Se utilizara este locale."
        lDESCGAMEMODE="Modo juego"
        lDESCDISK="Montar ubicacion como unidad."
        lTEXTVARIOSDISCOS="Selecciona el directorio para montar la unidad en el juego. Es decir, la microsd."
        lCOLUMNADISK="Directorio para mostrar la unidad"
        lTEXTFLAGS="Selecciona las variables/flags para correr el juego."
        lTEXTCONFIRMACION="A continuacion, se muestran los valores escogidos"
        lTEXTNOMBRE="Nombre"
        lTEXTEJECUTABLE="Ejecutable"
        lTEXTCONFIRMACION2="Seguro que quieres usar estos valores y continuar?"
        lCONTINUAR="Continuar"
        lSALIR="Salir"
        lTEXTDESPEDIDA="Fichero creado correctamente.\nGracias por usar este programa.\n\nSaludos."
        lTEXTERRORCREARFICHERO="Error al crear el fichero."
        lTEXTPREGUNTASRM="Quieres abrir Steam Rom Manager?"
        lBOTONSRM="Abrir SRM"
        ;;
    *)
        lTEXTERRORDIRECTORIO="There is no application directory required."
        lTEXTBIENVENIDA="Welcome to $NOMBRE.\nProgram to create shortcuts to our favorite games.\n\nThe wizard will be displayed next. Follow the instructions.\n\nLicense: GNU General Public License v3.0"
        lTEXTELEGIRPLUGIN="Select the appropriate plugin to choose the desired game."
        lTEXTERRORPLUGIN="The plugin has not returned any expected value."
        lCOLUMNADESC="Description"
        lTEXTPROTONELEGIR="Protons"
        lCOMBOPROTON="Select a Proton:"
        lDESCDXVK="Asynchronous synchronisation. Improves performance, but you may be banned in multiplayer."
        lDESCLANG="Language in Spanish. This locale will be used."
        lDESCGAMEMODE="Gamemode"
        lDESCDISK="Mount location as a unit."
        lTEXTVARIOSDISCOS="Select the directory to mount the drive in the game. That is, the microsd."
        lCOLUMNADISK="Directory to show like disk"
        lTEXTFLAGS="Select the variables/flags to run the game."
        lTEXTCONFIRMACION="The values chosen are shown below:"
        lTEXTNOMBRE="Name"
        lTEXTEJECUTABLE="Executable"
        lTEXTCONFIRMACION2="Are you sure you want to use these values and continue?"
        lCONTINUAR="Continue"
        lSALIR="Exit"
        lTEXTDESPEDIDA="File created successfully.\nThank you for using this program.\n\nBye bye."
        lTEXTERRORCREARFICHERO="Error creating file."
        lTEXTPREGUNTASRM="Do you want to open Steam Rom Manager?"
        lBOTONSRM="Open SRM"
        ;;
    esac
}

# Función para todas las comprobaciones iniciales
function checkInicial() {

    if ! zenity --help >/dev/null 2>/dev/null;then
        echo "(log) No se encuentra el programa zenity, necesario para esta apliación"
        exit 127
    fi

    [ ! -d "$DIRECTORIO" ] && echo "(log) No existe el directorio principal." && ERROR=SI
    [ ! -d "$DPLUGIN" ] && echo "(log) No existe el directorio de plugins." && ERROR=SI
    [ ! -d "$DGAMES" ] && echo "(log) No existe el directorio de games." && ERROR=SI
    [ ! -d "$DBIN" ] && echo "(log) No existe el directorio de ejecutables." && ERROR=SI

    if [ -n "$ERROR" ]; then
        zenity --error --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTERRORDIRECTORIO" 2>/dev/null
        exit 1
    fi
}

# Función de bienvenida
function bienVenida() {
    zenity --timeout 8 --info --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTBIENVENIDA" 2>/dev/null
}

# Función para seleccionar el plugin a ejecutar
function seleccionaPlugin() {
    PLUG="$DPLUGIN*.plugin"

    lista=()
    for i in $PLUG; do
        lista+=(FALSE "$(basename "$i")" "$(sed -n 4p "$i" | tr -d '#')")
    done

    PLUGIN=$(zenity --title="$NOMBRE v$VERSION" --list --radiolist --width=1000 --height=300 --text="$lTEXTELEGIRPLUGIN" \
        --column="Select?" \
        --column="PLUGIN" \
        --column="$lCOLUMNADESC" \
        "${lista[@]}" 2>/dev/null)

    if [ -z "$PLUGIN" ]; then
        echo "(log) No se selecciono ningun plugin. Saliendo"
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
        echo "(log) No hay protones."
    else

        PROTON=$(zenity --title="$NOMBRE v$VERSION" --forms --width=1000 --height=300 \
            --text="$lTEXTPROTONELEGIR" --add-combo="$lCOMBOPROTON" --combo-values="$protones" 2>/dev/null)

        if [ -z "$PROTON" ]; then
            echo -ne "(log) Se ha cancelado la eleccion de proton.\nSalimos."
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
    if [ ! "$num" -eq 0 ]; then
        lista+=(TRUE "DXVK_ASYNC=1" "$lDESCDXVK")
    fi

    lista+=(TRUE "LANG=es_ES.UTF-8" "$lDESCLANG")
    lista+=(TRUE "gamemoderun" "$lDESCGAMEMODE")

    num="$(find /run/media -mindepth 1 -maxdepth 1 -type d | wc -l)"
    if [ ! "$num" -eq 0 ]; then
        if [ "$num" -eq 1 ]; then
            num=$(find /run/media -mindepth 1 -maxdepth 1 -type d)
            lista+=(TRUE "STEAM_COMPAT_MOUNTS=$num" "$lDESCDISK")
        else
            echo "(log) Varias unidades montadas"
            lista2=()
            while IFS= read -r -d $'\0'; do
                lista2+=(FALSE "$REPLY")
            done < <(find /run/media -mindepth 1 -maxdepth 1 -type d -print0)

            num=
            num=$(zenity --title="$NOMBRE v$VERSION" --list --radiolist --width=1000 --height=300 \
                --text="$lTEXTVARIOSDISCOS" --column="Select?" --column="$lCOLUMNADISK" \
                "${lista2[@]}" 2>/dev/null)

            if [ "$num" != "" ]; then
                lista+=(TRUE "STEAM_COMPAT_MOUNTS=$num" "$lDESCDISK")
            fi
        fi
    fi

    num=$(zenity --title="$NOMBRE v$VERSION" --list --checklist --width=1000 --height=300 \
        --text="$lTEXTFLAGS" --column="Select?" --column="FLAG" --column="$lCOLUMNADESC" \
        "${lista[@]}" 2>/dev/null)

    FLAGS=$(echo "$num" | tr '|' ' ')
}

# Función para mostrar los valores que tenemos y esperar la confirmación del usuario
function mostrarConfirmar() {
    
    zenity --question \
        --title="$NOMBRE v$VERSION" --width=1000 --height=300 \
        --ok-label="$lCONTINUAR" --cancel-label="$lSALIR" \
        --text="$lTEXTCONFIRMACION\n\n$lTEXTNOMBRE: $NAMEF\n$lTEXTEJECUTABLE: $EXE\nProton: $PROTON\nFLAGS: $FLAGS\n\n\n$lTEXTCONFIRMACION2"
    ans=$?
    if [ ! $ans -eq 0 ]; then
        echo "(log) No quiere continuar. Salimos" && exit 3
    fi
}

# Función para pediro el nombre de archivo de salida .runner
function pedirNombre() {
    if [ -z "$NAMEF" ]; then
        NAMEF=$(zenity --entry \
            --title="runner4deck v$VERSION" --width=1000 --height=300 \
            --ok-label="Aceptar" \
            --text="Nombre del fichero o acceso directo: " 2>/dev/null)
    fi

    #Si el nombre de fichero no tiene extensión .runner, se le añade
    echo "$NAMEF" | grep .runner >/dev/null
    ans=$?
    if [ ! "$ans" -eq 0 ]; then
        NAMEF=$NAMEF".runner"
    fi

    NAME="$DGAMES""$NAMEF"
}

# Función para guardar el runner
function guardarRunner() {
    echo -ne "#! /bin/bash\n\n# VARIABLES RUNNER\nexport PROTON=\"$PROTON\"\nexport EXE=\"$EXE\"\n\
export ID=\"$ID\"\n\n# RESTO DE VARIABLES\n" | tee "$NAME"

    for i in $FLAGS; do
        echo "export $i" | tee -a "$NAME"
    done

    if [ -n "$SIPROTON" ]; then
        echo -ne "\nsource $DBIN""runner.sh\n\nexit 0" | tee -a "$NAME"
    else
        echo -ne "\neval \$EXE\n\nexit 0" | tee -a "$NAME"
    fi

    chmod +x "$NAME"
}

# Función para comprobar que se ha creado el fichero y despedirse
function checkBye() {
    if [ -f "$NAME" ]; then
        zenity  --timeout 4 --info --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTDESPEDIDA" 2>/dev/null
    else
        zenity --error --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTERRORCREARFICHERO" 2>/dev/null
        exit 1
    fi
}

# Función como postdata para abrir o no Steam Rom Manager
function abrirSRM() {
    texto="Quieres abrir Steam Rom Manager?"

    zenity --question --title="$NOMBRE v$VERSION" --width=250 --ok-label="$lBOTONSRM" --cancel-label="$lSALIR" --text="$lTEXTPREGUNTASRM" 2>/dev/null

    ans=$?
    if [ $ans -eq 0 ]; then
        flatpak run com.steamgriddb.steam-rom-manager        
    fi
}
##########################################################################################
# MAIN - PRINCIPAL
##########################################################################################
# Cargamos el idioma
fLanguage

# Mostramos nombre de programa y versión
echo "(log) $NOMBRE vers. $VERSION"
bienVenida

# Paso 0 --> Chequeamos todos los parámetros iniciales
checkInicial

# Paso 1 --> listar los plugins y seleccionar uno
echo "(log) Seleccionando plugin."
seleccionaPlugin
# En la variable PLUGIN tenemos el plugin a ejecutar

# Paso 2 --> ejecutar ese plugin, le damos el control
# shellcheck source=/dev/null
source "$DPLUGIN$PLUGIN"
if [ -z "$EXE" ]; then
    echo "(log) El plugin no ha devuelto un ejecutable. Salimos"
    zenity --error --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTERRORPLUGIN" 2>/dev/null
    exit 2
fi
# Tenemos en la variable EXE el ejecutable.
# Si es necesario, también se rellenan otras variables: PROTON, ID, ..

# Paso 3 --> Si el plugin definió que es necesario un Proton, se pregunta por él
if [ -n "$SIPROTON" ]; then
    echo "(log) Seleccionando proton."
    menuProton
    # En la variable PROTON tenemos el proton a elegir

    echo "(log) Seleccionando FLAGS"
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
