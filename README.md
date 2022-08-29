# runner4deck [BETA] - doc. en contrucción
_**Crea tus accesos directos a juegos desde tiendas oficiales y otras herramientas en SteamOS.**_

![PLUGIN](https://raw.githubusercontent.com/FranjeGueje/runner4deck/master/doc/Plugins.png)

![EPIC](https://raw.githubusercontent.com/FranjeGueje/runner4deck/master/doc/Epic.png)

Esta utilidad crea accesos directos a juegos instalados en otras herramientas/launchers. Actualmente, para lanzadores de tiendas oficiales como pueden ser Epic Games, GOG Galaxy y Origin, **runner4deck** puede crear accesos directos con extensión .runner que acceden directamente al juego. Sí, haciendo doble clic en estos archivos .runner arrancarás el juego.

Estos accesos directos se pueden agregar directamente a Steam de forma manual o como se recomienda en esta guía, se puede utilizar "Steam Rom Manager" para que los archivos .runner se añadan automáticamente con sus carátulas a Steam de forma directa. Además de los mencionados anteriormente, **runner4deck** también busca juegos instalados en Lutris (fuera de Proton) y permite agregarlos a Steam con sus imágenes.

## ¿Por qué esta herramienta?
Al igual que más gente, odio los launchers en general. No me gusta ninguno. No me gusta tener un enorme número de tiendas y lanzadores para todos mis juegos. **runner4deck** busca poder añadir y  arrancar juegos directamente con su launcher por en segundo plano.

Existen muchos launchers y herramientas en GNU Linux para descargar y ejecutar juegos de Epic, GOG, u Origin. Estas pueden ser: Lutris, Heroic,... Pero estas herramientas no son oficiales y características como guardado en la nube, descargas de algunos juegos, ... no funcionan correctamente. Por otro lado, si utilizamos el launcher oficial añadido a Steam como "Juego no Steam", todos sabemos las molestias que puede generar esto: tener un único lanzador para los juegos de Epic y tener que hacer clic con el dedo para ejecutarlos, además, ¡perdemos la posibilidad de crear distintos perfiles para juegos ya que el lanzador es el mismo para todos!

Sí o sí hay que tener launchers para descargar, hay que hacer login en el launcher oficial o en Heroic o donde sea, pero hay que hacerlo. ¿Cómo lo haría con este método? Sencillo, descarga en SteamOS los launcher para Windows (.exe o .msi) y añádelos a Steam como "Juego no Steam" con compatibilidad Proton.

**SÓLO**, **sólo** arrancaremos estos launchers para: descargar juegos, para sincronizar partidas o para actualizar el propio launcher. No es necesario para arrancar ningún juego.

**runner4deck** actualmente posee plugins para:
- Epic Games Launcher (sobre Proton, añadido como "Juego no Steam"): busca y muestra todos los juegos instalados desde este sistema.
- GOG Galaxy (sobre Proton, añadido como "Juego no Steam"): se debe de buscar el juego ya instalado manualmente y navegando en el asistente.
- Origin (sobre Proton, añadido como "Juego no Steam"): se debe de buscar el juego ya instalado manualmente y navegando en el asistente.
- Lutris: busca y muestra todos los juegos instalados desde esta herramienta.
- ...
- Es totalmente escalable: se podrá ampliar la funcionalidad y añadir nuevos plugins para otros launchers/herramientas. El siguiente plugin que estoy pensando sería para juegos portables... :)

## Entonces resúmeme como funciona runner4deck
* Descarga e instala tus launchers oficiales como "Juegos no Steam" con compatibilidad proton.
* Cambia el ejecutable de ese launcher al ejecutable del launcher y no al instalador. Si no, cuando corras este en Steam siempre te saltará el instalador.
* Arranca el launcher y descarga uno o varios juegos. Cierra el launcher.
* Lanza **runner4deck** y sigue el asistente.
* Selecciona el plugin adecuado y crea tu acceso en el directorio "games" dentro de $HOME/runner4deck.
* Si exploras la ubicación $HOME/runner4deck/games verás los juegos que has ido añadiendo con el asistente.
* Si por casualidad ejecutas cualquier juego .runner el juego debería de ejecutarse directamente y si es necesario, te abrirá el launcher.
* Como último paso, añade el .runner como "Juego no Steam" manualmente **sin compatibilidad** ó arranca "Steam Rom Manager" y deja que te los añada todos a la vez con todas sus imágenes.

## ¿Cómo configuro Steam Rom Manager?
Debes de crear un nuevo "Parser" por ejemplo llamado Runners. Que básicamente, los ficheros que tengan extensión ".runner" los lanzará desde Steam añadiéndolos como "Juego no Steam" además de buscar las imágenes en SteamGridDB con el nombre del fichero. Por eso, es importante que **el nombre del fichero sea lo más parecido al nombre real o al menos el que tenga en SteamGridDB**. Aquí os dejo mi configuración para Steam Rom Manager

![SRM-1](https://raw.githubusercontent.com/FranjeGueje/runner4deck/master/doc/SRM-1.png)

![SRM-2](https://raw.githubusercontent.com/FranjeGueje/runner4deck/master/doc/SRM-2.png)

## runner4deck ES una aplicación para ti si...
- Usas, o te gustaría usar, launcher oficiales añadidos a Steam como "Juego no Steam"
- Quieres usar las bonanzas de tener el launcher oficial. Sí, lo siento siempre, uses el método que uses incluso en Heroic, ... necesitas iniciar sesión para descargar juegos.
- Quieres tener un proton para cada juego aunque compartan el mismo compatdata.
- Quieres tener un perfil de mando para cada juego distinto.
- Además de lo anterior, también puedes tener un perfil de energía por juego aunque compartan el mismo compatdata.
- Odias tener COMPATDATA en enormes cantidades, perdidos, sin nombre, ...: Con este método sólo usarás un COMPATDATA, un prefijo de wine/proton, por launcher.

## runner4deck NO es una aplicación para ti si...
- Estas contento actualmente con tu forma de descargar y jugar: Heroic, ...
- Te gusta segmentar y tener tus COMPATDATA diferenciados por juego.

## Instalar
Ejecuta en una línea de comandos:

`curl https://raw.githubusercontent.com/FranjeGueje/runner4deck/master/INSTALL/install.sh | bash -s`

No necesitas ser root. Este comando `install.sh` descarga el proyecto mediante git y hace un build con las herramientas necesarias. Todo lo empaqueta en un único directorio _**$HOME/runner4deck**_.

## Ejecución
Para la ejecución de runner4deck, corre directamente `runner4deck.sh` y te aparecerá el menú del asistente.

# FAQ
## ¿Cómo se instala?
Fácil: Abre un terminal/consola y ejecuta este comando:

**`curl https://raw.githubusercontent.com/FranjeGueje/runner4deck/master/INSTALL/install.sh | bash -s`**

El asistente de instalación lo hará todo por ti y tendrás la última versión de la herramienta.

## ¿Dónde se instala?
Por defecto, se instala en la HOME del usuario, en el directorio **`$HOME/runner4deck`**. Si usas Deck, en /home/deck/runner4deck lo tendrás instalado.

## No me gusta esa ubicación, ¿puedo cambiarla?
De momento no recomiendo cambiarla. Aunque puede editar los scripts y configurarte manualmente las ubicaciones.

## ¿Dónde se instalan los accesos a los juegos?
Por defecto runner4deck lo guarda en la capeta HOME, dentro de una subcarpeta llamada "runner4deck/games". Es decir, en SteamOS en **/home/deck/runner4deck/games**

## ¿Se puede cambiar la ubicación de instalación de videojuegos?
De momento no recomiendo cambiarla. Aunque puede editar los scripts y configurarte manualmente las ubicaciones.

## ¿Cómo se desinstala? No quiero ningún resto.
Simple. Para desinstalalar runner4deck únicamente borra las carpetas con sus subcarpetas y ficheros:
* $HOME/runner4deck
* $HOME/.local/share/applications/runner4deck.desktop

## Parece que sacas versiones continuamente, que estás mejorándolo, ¿como me actualizo a la última versión?
Fácil, salva tu carpeta de acceso a juegos ($HOME/runner4deck/games); borra la carpeta de runner4deck (recuerda, la carpeta por defecto está en $HOME/runner4deck) y lanza el comando de instalación desde un terminal/consola. Se volverá a descargar la última versión. Restaura los accesos guardados anteriormente en la carpeta games.

# TODO
- Mejorar Wizard; pulir fallos. Recuerda que estamos en versión beta.
- ¿Añadir nuevos plugins?
- ...
- Reparar, reparar, reparar, ...
- ...
