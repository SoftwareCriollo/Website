|  _ \           | |               | |
| |_) | __ _ _ __| |_ ___ _ __   __| | ___ _ __
|  _ < / _` | '__| __/ _ \ '_ \ / _` |/ _ \ '__|
| |_) | (_| | |  | ||  __/ | | | (_| |  __/ |
|____/ \__,_|_|   \__\___|_| |_|\__,_|\___|_|
`

*This is a base project we use to start the party with Sinatra*

Gems:
-----

Sinatra
RSpec
Slim
SASS


Pasos a seguir para modificar los estilos de la app:

En la Carpeta '/assets' se encuentran todos los bienes de la app.
Ejemplo:
  - '/assets/css'
  - '/assets/images'
  - '/assets/js'

Para los CSS
  - Debemos modificar el archivo '/assets/css/general.css'
  - Dentro de el tendremos varias etiquetas de comentario que dividen la aplicacion segun sus vistas: index, ourservices, getintouch, tambien la primera parte 'general' en donde se encuentran los estilos generales de la app.

Para generar el archivo '/assets/css/general.min.css', que es el que cargamos en la app.
  - Debemos ejecutar este comando en nuestra consola: rake minify
  - Y nos aparecera algo como esto:
    $ rake minify
      Building...
       * initialize_sc_account.min.js
       * general.min.css
      Construction complete!
    $

Ahora solo nos queda ejecutar la app con unicorn y listo:
  $ unicorn

Se utilizo esta informacion para comprimir y minimizar los asstes.
  - http://www.rubydoc.info/gems/sinatra-minify/0.2.3#Ignore_minified_files_in_source_control