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

DIRECTORIO="$(dirname "$(realpath "$0")")/"
DPLUGIN="$DIRECTORIO"plugins/
DGAMES="$DIRECTORIO"games/
DBIN="$DIRECTORIO"bin/

# Lista principal de juegos a añadir
LISTAPRINCIPAL=()


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
            lTEXTELEGIRJUEGOS="Selecciona los juegos a añadir a Steam:"
            lCOLUMNASELECC="[*]"
            lCOLUMNALAUNCHER="Launcher"
            lCOLUMNANOMBREJUEGO="Nombre del Juego"
            lCOLUMNAIDAPPSTEAM="Nombre e ID de Steam"
            lTEXTERRORNOJUEGOS="No se ha encontrado ningun juego"
            lTEXTPROTONELEGIR="Valores de Proton"
            lTEXTNOPROTONES="No existen Proton(es) para ejecutar juegos."
            lCOMBOPROTON="Seleccione un Proton:"
            lTEXTNOSELECPROTONES="No has seleccionado ningún Proton"
            lTEXTCONFIRMACION="A continuacion, se muestran los valores escogidos"
            lCONTINUAR="Continuar"
            lSALIR="Salir"
            lTEXTCANCELARJUEGO="Cancelando la creación de este juego."
            lTEXTDESPEDIDA="Gracias por usar este programa.\n\nSaludos."
        ;;
        *)
            lTEXTERRORDIRECTORIO="There is no application directory required."
            lTEXTBIENVENIDA="Welcome to $NOMBRE.\nProgram to create shortcuts to our favorite games.\n\nThe wizard will be displayed next. Follow the instructions.\n\nLicense: GNU General Public License v3.0"
            lTEXTELEGIRJUEGOS="Select the games to add to Steam:"
            lCOLUMNASELECC="[*]"
            lCOLUMNALAUNCHER="Launcher"
            lCOLUMNANOMBREJUEGO="Game"
            lCOLUMNAIDAPPSTEAM="Name and ID of Steam"
            lTEXTERRORNOJUEGOS="No game found"
            lTEXTPROTONELEGIR="Protons"
            lTEXTNOPROTONES="There are no Proton(s) to run games."
            lCOMBOPROTON="Select a Proton:"
            lTEXTNOSELECPROTONES="You have not selected a Proton"
            lTEXTCONFIRMACION="The values chosen are shown below:"
            lCONTINUAR="Continue"
            lSALIR="Exit"
            lTEXTCANCELARJUEGO="Canceling the creation of this game."
            lTEXTDESPEDIDA="Thank you for using this program.\n\nBye bye."
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
function ejecutaPlugins() {
    PLUG="$DPLUGIN*.plugin"
    
    for i in $PLUG; do
        # shellcheck source=/dev/null
        source "$i"
    done
    
    if [ ${#LISTAPRINCIPAL[@]} -eq 0 ]; then
        [ -n "$DEBUG" ] && echo "(log) No se ha encontrado ningún juego."
        zenity --error --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTERRORNOJUEGOS" 2>/dev/null
    fi
    
    [ -n "$DEBUG" ] && echo -ne "(log) Valores de la variable LISTAPRINCIPAL:" "${LISTAPRINCIPAL[@]}" " ---- Fin\n"
    
}

# Función para seleccionar los juegos
function seleccionaJuegos() {
    
    JUEGOS=$(zenity --title="$NOMBRE v$VERSION" --list --checklist --width=1000 --height=300 \
        --text="$lTEXTELEGIRJUEGOS" \
        --column="$lCOLUMNASELECC" --column="Ejecutable" --column="$lCOLUMNALAUNCHER" --column="$lCOLUMNANOMBREJUEGO" --column="$lCOLUMNAIDAPPSTEAM" \
    --separator="|" --hide-column=2 "${LISTAPRINCIPAL[@]}")
    
    if [ -z "$JUEGOS" ]; then
        zenity --timeout 3 --info --title="$NOMBRE v$VERSION" --width=250 --text="No has elegido ningún juego" 2>/dev/null
        exit 0
    else
        [ -n "$DEBUG" ] && echo "(log) Seleccionado $JUEGOS"
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
        [ -n "$DEBUG" ] && echo "(log) No hay protones."
        zenity --timeout 5 --error --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTNOPROTONES" 2>/dev/null
        exit 2
    else
        
        PROTON=$(zenity --title="$NOMBRE v$VERSION" --forms --width=1000 --height=300 \
        --text="$lTEXTPROTONELEGIR" --add-combo="$lCOMBOPROTON" --combo-values="$protones" 2>/dev/null)
        
        ans=$?
        if [ ! $ans -eq 0 ] || [ ! -f "$PROTON" ]; then
            [ -n "$DEBUG" ] && echo "(log) Se ha cancelado la eleccion de proton. Salimos."
            zenity --timeout 5 --error --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTNOSELECPROTONES" 2>/dev/null
            exit 1
        fi
    fi
    
    [ -n "$DEBUG" ] && echo "(log) El valor de PROTON es $PROTON."
    
}

# Función para seleccionar los flags o banderas para nuestro programa que se ejecuta en proton
function menuFlags() {
    FLAGS=()
    num=$(dirname "$PROTON" | grep GE -c)
    if [ ! "$num" -eq 0 ]; then
        FLAGS+=("DXVK_ASYNC=1")
    fi
    
    [ -n "$DEBUG" ] && echo "(log) Valores de FLAGS" "${FLAGS[@]}"
}

# Función para mostrar los valores que tenemos y esperar la confirmación del usuario
function mostrarConfirmar() {
    
    zenity --question \
    --title="$NOMBRE v$VERSION" --width=1000 --height=300 \
    --ok-label="$lCONTINUAR" --cancel-label="$lSALIR" \
    --text="$lTEXTCONFIRMACION\n\n$(cat "$NAMETEMP")"
    ans=$?
    if [ ! $ans -eq 0 ]; then
        [ -n "$DEBUG" ] && echo "(log) No quiere aplicar este juego."
        zenity --timeout 3 --info --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTCANCELARJUEGO" 2>/dev/null
    else
        cp "$NAMETEMP" "$NAME" && chmod +x "$NAME"
        [ -n "$DEBUG" ] && echo "(log) Creado el lanzador del juego en $NAME."
        aniadirSteam
    fi
    
}

# Función para guardar el runner
function guardarRunner() {
    # Generamos juego a juego y pedimos confirmación
    NAMETEMP=/tmp/runnerGame.runner
    IFS="|"
    for i in ${JUEGOS}; do
        EXE=$(echo "$i" | cut -d '#' -f1)
        NAMEF=$(echo "$i" | cut -d '#' -f2)
        ID=$(echo "$i" | cut -d '#' -f3)
        PARAM=$(echo "$i" | cut -d '#' -f4)
        
        NAME="$DGAMES""$NAMEF"
        echo -ne "#! /bin/bash\n\n# VARIABLES RUNNER\nexport PROTON=\"$PROTON\"\nexport ID=\"$ID\"\n\
export EXE=\"$EXE\"\nexport PARAM=\"$PARAM\"\n\n# RESTO DE VARIABLES\n" | tee "$NAMETEMP" > /dev/null
        
        for j in "${FLAGS[@]}"; do
            echo "export $j" | tee -a "$NAMETEMP" > /dev/null
        done
        
        echo -ne "\nsource $DBIN""runner.sh\n\nexit 0" | tee -a "$NAMETEMP"> /dev/null
        
        mostrarConfirmar
    done
    unset IFS
    rm -f "$NAMETEMP"
}

# Función para c despedirse
function bye() {
    zenity  --timeout 4 --info --title="$NOMBRE v$VERSION" --width=250 --text="$lTEXTDESPEDIDA" 2>/dev/null
}

# Función para c despedirse
function aniadirSteam() {
    encodedUrl="steam://addnonsteamgame/$(python3 -c "import urllib.parse;print(urllib.parse.quote(\"$NAME\", safe=''))")"
    touch /tmp/addnonsteamgamefile
    xdg-open "$encodedUrl"
}

##########################################################################################
# MAIN - PRINCIPAL
##########################################################################################
# Cargamos el idioma
fLanguage

# Mostramos nombre de programa y versión
[ -n "$DEBUG" ] && echo "(log) ***********$NOMBRE vers. $VERSION"
bienVenida

# --> Chequeamos todos los parámetros iniciales
[ -n "$DEBUG" ] && echo "(log) ***********Chequeo inicial"
checkInicial

# --> Ejecutar los plugins y crear la lista LISTAPRINCIPAL
[ -n "$DEBUG" ] && echo "(log) ***********Ejecutamos todos los plugins. En busca de juegos"
ejecutaPlugins

# --> Seleccionamos los juegos de la lista LISTAPRINCIPAL
[ -n "$DEBUG" ] && echo "(log) ***********Seleccionamos juegos de la LISTAPRINCIPAL"
seleccionaJuegos
# en la variable JUEGOS tenemos los juegos seleccionados para añadirlos

# --> Si el plugin definió que es necesario un Proton, se pregunta por él
[ -n "$DEBUG" ] && echo "(log) ***********Seleccionando proton."
menuProton
# En la variable PROTON tenemos el proton a elegir

# --> Generamos las variables y FLAGs que queremos
[ -n "$DEBUG" ] && echo "(log) ***********Añadiendo FLAGS"
menuFlags
# En la variable FLAGS tenemos las variables a usar

# --> Guardamos el acceso directo preguntando antes
[ -n "$DEBUG" ] && echo "(log) ***********Guardando los ficheros"
guardarRunner

# --> Despedida
[ -n "$DEBUG" ] && echo "(log) ***********Despedida"
bye

exit 0
