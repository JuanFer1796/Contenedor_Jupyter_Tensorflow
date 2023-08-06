# Contenedor_Jupyter_Tensorflow
Una imagen de Jupyter Notebooks con tensorflow

## 1. Creación de la imagen
Utiliza el siguiente comando para crear la imagen Docker:

```
docker build -t jupyter .
```

La bandera `-t` especifica que queremos darle un nombre específico a la imagen (en nuestro caso `jupyter`). 

El `.` al final del comando especifica el directorio en el que se encuentra el *Dockerfile*. En nuestro caso, este es nuestro directorio de trabajo actual, que especificamos con un punto.

## 2. Inicio del contenedor
Utiliza el siguiente comando para iniciar el contenedor:

```
docker run -it -p 8888:8888 -v "$(pwd)/project:/project" jupyter
```

La bandera `-it` especifica que se debe ejecutar el contenedor en modo interactivo (es decir, imprimir la salida del contenedor en nuestra terminal).

La bandera `-p` especifica que queremos mapear el puerto 8888 del contenedor (el que está después de los dos puntos) al puerto 8888 de nuestra máquina anfitriona (el que está antes de los dos puntos). Esto redirige efectivamente nuestro localhost:8888 al localhost:8888 del contenedor, que es donde se está ejecutando el servidor de notebooks.

La bandera `-v` especifica que queremos compartir una carpeta con el contenedor, lo que significa que los archivos pueden ser intercambiados al instante y también persistir en nuestra máquina anfitriona después de que el contenedor se detenga. La parte antes de los `:` especifica la carpeta *project* en nuestro directorio de trabajo actual (de ahí `$(pwd)`) como nuestro extremo del intercambio de carpetas. La parte después de los `:` especifica la ruta absoluta del respectivo extremo en el contenedor. También es el directorio que el contenedor ya está utilizando (como se especifica en el Dockerfile), lo que significa que todos los archivos en la carpeta de proyecto serán visibles al iniciar el notebook de Jupyter.

El `jupyter` al final es el nombre de la imagen que queremos usar.

## 3. Acceso al notebook
El contenedor imprime el registro del kernel de Jupyter en la terminal. Al abrir el enlace `http://127.0.0.1:8888/?token=...` en un navegador, se abre la interfaz del servidor de Jupyter creado por el contenedor. Ahora puedes simplemente usar los notebooks de Jupyter como si se ejecutaran en tu propia máquina (que aún lo hacen, técnicamente, pero el contenedor no lo sabe y por lo tanto debemos actuar como si no lo supiera).

## 4. Almacenamiento y acceso a archivos
Este contenedor no almacena nada de lo que hiciste después de iniciar el contenedor una vez que se detiene. Es por eso que reflejamos la carpeta *project* en el contenedor (especificado por la bandera `v` en el comando `docker run`). Cualquier cambio realizado dentro de esa carpeta es instantáneamente efectivo en la carpeta *project* dentro del contenedor y viceversa.

El contenedor inicia dentro de esta carpeta de proyecto por defecto. Por lo tanto, cualquier notebook colocado en nuestra carpeta de proyecto también existe en el contenedor. Cualquier salida almacenada en la carpeta *project* del contenedor persiste en nuestro sistema anfitrión incluso después de que el contenedor se detenga.

## 5. Detener el Contenedor
Simplemente presiona `CTRL+C` en la terminal que muestra el kernel del notebook de Jupyter y confirma con `y`. Esto debería detener el contenedor. Si no lo hace, abre otra terminal, ejecuta `docker ps` para obtener una lista de los contenedores en ejecución y sus respectivos nombres. Luego ejecuta `docker stop <nombre_del_contenedor>`. El nombre del contenedor es algo como *stoic_hamilton* y se asigna automáticamente a un contenedor cuando se inicia. Si eso tampoco funciona, ejecuta `docker kill <nombre_del_contenedor>`.

## 6. Abrir la terminal del contenedor
Ejecutar `docker run` con esta imagen convertirá la terminal en la salida del kernel de Jupyter, donde no podrás introducir más comandos. Si deseas entrar a la terminal del contenedor en ejecución, ejecuta 
```
docker ps
```
para obtener una lista de los contenedores en ejecución y sus respectivos nombres. Luego ejecuta el siguiente comando para entrar al contenedor:
```
docker exec -it <nombre_del_contenedor> /bin/bash
```
## 7. Instalación de nuevas bibliotecas

Existen dos formas de instalar nuevas bibliotecas en tu contenedor Docker:

1. **Actualización del archivo `requirements.txt`**: Si sabes de antemano que necesitarás ciertas bibliotecas, puedes agregarlas al archivo `requirements.txt` antes de construir la imagen Docker. Cada línea en `requirements.txt` es una biblioteca que `pip` instalará, por lo que simplemente puedes agregar una nueva línea con el nombre de la biblioteca que desees instalar. Después de actualizar `requirements.txt`, tendrás que reconstruir la imagen Docker con el comando `docker build -t jupyter .` y luego iniciar un nuevo contenedor con esa imagen.

2. **Instalación en un contenedor en ejecución**: Si ya tienes un contenedor en ejecución y necesitas instalar una nueva biblioteca, puedes hacerlo abriendo una nueva terminal en el contenedor. Primero, necesitarás obtener el nombre del contenedor utilizando `docker ps`, luego puedes abrir una nueva terminal con `docker exec -it <nombre_del_contenedor> /bin/bash`. Una vez que estés en la terminal del contenedor, puedes usar `pip` para instalar nuevas bibliotecas como lo harías normalmente, por ejemplo, `pip install <nombre_de_la_biblioteca>`. Ten en cuenta que cualquier biblioteca que instales de esta manera no persistirá si detienes y reinicias el contenedor. Para hacer persistente la instalación de la biblioteca, necesitas agregarla a `requirements.txt` y reconstruir la imagen.
