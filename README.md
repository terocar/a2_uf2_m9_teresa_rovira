# Ubuntu Dev Container with GUI Access

Contenedor Docker con Ubuntu 24.04 que incluye:

- Entorno gráfico XFCE

- Servidor VNC para acceso remoto

- Visual Studio Code

- Python 3 y herramientas de desarrollo

- Servidor SSH

## Requisitos previos

- Docker instalado

- Cliente VNC (como Remmina o TigerVNC)

## Configuración del contenedor

### 1. Construir la imagen

```bash

docker build -t ubuntu-dev-env -f Dockerfile-dev-env .

```

### 2. Ejecutar el contenedor

```bash

docker run -d \

--name dev-container \

-p 5901:5901 \

-p 2222:22 \

ubuntu-dev-env

```

### 3. Conectar via VNC

- **Servidor:** `localhost:5901`

- **Contraseña:** `devpass`

- **Configuración recomendada en Remmina:**

- Protocolo: VNC

- Calidad de color: High (24 bits)

- Escalar automáticamente: Activado

### 4. Conectar via SSH

```bash

ssh devuser@localhost -p 2222

```

**Contraseña:** `devpass`

### 5. Iniciar Visual Studio Code

Desde la terminal dentro del entorno gráfico XFCE:

```bash

code --disable-gpu-sandbox

```

## Solución de problemas

### Si VSCode no inicia

Ejecuta en la terminal del contenedor (dentro de XFCE):

```bash

sudo chown -R devuser:devuser ~/.vscode

```

### Reiniciar servicio VNC

```bash

docker exec dev-container pkill vncserver

docker exec dev-container su - devuser -c "vncserver :1"

```

### Problemas de conexión VNC

Verifica que el contenedor está corriendo:

```bash

docker ps -a

```

## Gestión del contenedor

- **Detener contenedor:** `docker stop dev-container`

- **Iniciar contenedor:** `docker start dev-container`

- **Eliminar contenedor:** `docker rm -f dev-container`

- **Acceder a la terminal del contenedor:** `docker exec -it dev-container bash`

## Estructura del proyecto

```

repo/

├── Dockerfile-dev-env          # Dockerfile principal

├── container-init.sh           # Script de inicio del contenedor

├── README.md                   # Este archivo

└── (opcional) otros archivos de configuración

```

## Notas importantes

1. La primera construcción puede tardar 15-20 minutos debido a la descarga e instalación de paquetes.

2. Para desarrollo real, se recomienda mapear un directorio local con tu código:

```bash

docker run -d \

--name dev-container \

-p 5901:5901 \

-p 2222:22 \

-v $(pwd)/tu_codigo:/home/devuser/code \

ubuntu-dev-env

```

3. El flag `--disable-gpu-sandbox` es necesario para VSCode en entornos virtualizados sin soporte completo de sandboxing de GPU.

```