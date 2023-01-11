#! /bin/bash
#/////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////#
# Plantilla para arrancar juegos mediante Bash Script
#/////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////#

# Realizado por Paco Guerrero fjgj1@hotmail.com

# Función de ayuda
function showhelp() {
    echo -ne "Uso de la herramienta:\n\n\t\t$0 -c [O | E | G | ID] -e exec [-p PROTON] [-a \"param del exe\"] [-v variable1 variable2 ...]\n\
    \n[Opciones]\n\
    \t-h|--help\t\t\tEsta ayuda.\n\
    \t-c|--cd\t\t Launcher o ID\tO: Origin | Epic Games | GOG | ID de Steam; launcher o id donde se encuentra su compatdata.\n\
    \t-e|--exec\t EXE\t\tEjectutable que lanzará Proton.\n\
    \t-a|--params\t PARAM\t\tParámetros del ejectutable que lanzará Proton.\n\
    \t-p|--proton\t PROTON\t\tRuta del Proton que queremos utilizar. Si no se elige uno, la herramienta buscará uno.\n\
    \t-v|--vars\t var1 ...\tVariables de entorno para Proton en caso de querer pasarle.\n"
    exit 1
}

#/////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////#
#######################################################################################
##                            Comienzo de ejecución                                  ##
#######################################################################################

# Recogemos los argumentos
while [ $# -ne 0 ]; do
    case "$1" in
    -h | --help)
        # No hacemos nada más, porque showhelp se saldrá del programa
        echo ayuda
        ;;
    -e | --exec)
        EXE="$2"
        shift
        ;;
    -c | --cd)
        if [ -z "$ID" ]; then
            ID="$2"
            shift
        else
            echo -ne "Ya se definió este parámetro -c .\n"
            showhelp
            exit 1
        fi
        ;;
    -p | --proton)
        PROTON="$2"
        shift
        ;;
    -v | --vars)
        while [ $# -ne 0 ]; do
            FLAGS+=("$2")
            shift
        done
        break
        ;;
    -a | --params)
        PARAM="$2"
        shift
        ;;
    *)
        echo "Argumento no válido.// Something is wrong..."
        showhelp
        exit 1
        ;;
    esac
    shift
done

if [[ -z "$EXE" ]] || [[ -z "$ID" ]]; then
    echo "Falan argumentos necesarios."
    showhelp
    exit 1
fi

# Definimos el COMPATDATA a través del ID
case "$ID" in
O | o)
    STEAM_COMPAT_DATA_PATH="$(readlink /home/deck/.steam/root/steamapps/compatdata/Origin)"
    ;;
E | e)
    STEAM_COMPAT_DATA_PATH="$(readlink /home/deck/.steam/root/steamapps/compatdata/Epic)"
    ;;
G | g)
    STEAM_COMPAT_DATA_PATH="$(readlink /home/deck/.steam/root/steamapps/compatdata/GOG)"
    ;;
U | u)
    STEAM_COMPAT_DATA_PATH="$(readlink /home/deck/.steam/root/steamapps/compatdata/Ubisoft)"
    ;;
*)
    STEAM_COMPAT_DATA_PATH="/home/deck/.local/share/Steam/steamapps/compatdata/$ID"
    ;;
esac

export STEAM_COMPAT_DATA_PATH

# Si hemos definido PROTON, lo usamos. Si no, por defecto, usaremos el experimiental; si existe el fichero "PROTON.config", usará ese mejor que será el GE que tengamos
[ -z "$PROTON" ] && PROTON="/home/deck/.steam/root/steamapps/common/Proton - Experimental/proton"

if [ ! -f "$PROTON" ]; then
    echo "No se ha señalado ningún Proton y no se encuentra uno para correr".
    exit 2
fi

# Resto de variables de Steam
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam/"
export WINEPREFIX="$STEAM_COMPAT_DATA_PATH/pfx"
export STEAM_COMPAT_MOUNTS="$MICROSD"

for i in "${FLAGS[@]}"; do
    export "$i" 2>/dev/null
done

UBICACION="$(dirname "$EXE")"

echo -ne "*********************\nProton: $PROTON\nEjecutable: $EXE\nUbicacion: $UBICACION\nBanderas: " "${FLAGS[@]}" "\n\
MicroSD: $STEAM_COMPAT_MOUNTS\nSteam: $STEAM_COMPAT_CLIENT_INSTALL_PATH\nDataPath: $STEAM_COMPAT_DATA_PATH\nWinePrefix: $WINEPREFIX\n*********************"
echo -ne "\nLanzando el juego...\n"

if [[ ! -d "$STEAM_COMPAT_DATA_PATH" ]] || [[ ! -d "$STEAM_COMPAT_CLIENT_INSTALL_PATH" ]] || [[ ! -d "$WINEPREFIX" ]] || \
[[ ! -f "$PROTON" ]]; then
    echo "No existe algún fichero definido"
    exit 1
fi

cd "$UBICACION" 2>/dev/null || cd "$STEAM_COMPAT_DATA_PATH" 2>/dev/null || echo "Sin poder saltar a un directorio."
"$PROTON" run "$EXE" "$PARAM"
