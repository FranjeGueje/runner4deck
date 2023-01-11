# UBISOFT CONNECT
# Fix 1: Que arranquen los juegos directamente sin pasar por el launcher.
Es necesario el Escritorio Virtual:
Al fichero "..../pfx/user.reg" del compatdata de Ubisoft Connect añadir:

[Software\\Wine\\Explorer] 1662063542
#time=1d8be401398bd86
"Desktop"="Default"

[Software\\Wine\\Explorer\\Desktops] 1662063542
#time=1d8be401398bc50
"Default"="1280x800"



# Fix 2: Errores de siempre conectar
Instalar estas librerías con pacman que a día de hoy SteamOS no las tiene añadidas:

#Deshabilitamos el sólo lectura
sudo steamos-readonly disable
#Inicializamos pacman
sudo pacman-key --init
sudo pacman-key --populate archlinux
#Instalamos la fuente
sudo pacman -S lib32-gnutls --noconfirm
#Volvemos a dejar todo como solo lectura
sudo steamos-readonly enable



# Fix 3: Mejoramos el comportamiento del launcher Ubisoft Connect
Se quita el overlay de sus juegos, ... 
En el fichero "...../drive_c/users/$USER/Local Settings/Application Data/Ubisoft Game Launcher/settings.yaml" comprobamos que tenga

overlay:
  enabled: false
  forceunhookgame: false
  fps_enabled: false
  warning_enabled: false
user:
  closebehavior: CloseBehavior_Close

# ORIGIN
# Fix 1: Que arranquen los juegos directamente sin pasar por el launcher.
Es necesario el Escritorio Virtual:
Al fichero "..../pfx/user.reg" del compatdata de Origin añadir:

[Software\\Wine\\Explorer] 1662063542
#time=1d8be401398bd86
"Desktop"="Default"

[Software\\Wine\\Explorer\\Desktops] 1662063542
#time=1d8be401398bc50
"Default"="1280x800"
