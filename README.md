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
docker build -t ubuntu-dev-env -f dockerfile .
```

### 2. Ejecutar el contenedor

```bash
docker run -d \
  --name dev-box \
  -p 5901:5901 \
  -p 2222:22 \
  ubuntu-dev-env
```

### 3. Conectar vía VNC

- **Servidor:** `localhost:5901`  
- **Contraseña:** `developer`  
- **Configuración recomendada en Remmina:**
  - Protocolo: VNC
  - Calidad de color: Alta (24 bits)
  - Escalar automáticamente: Activado

### 4. Conectar vía SSH

```bash
ssh developer@localhost -p 2222
```

**Contraseña:** `developer`

### 5. Iniciar Visual Studio Code

Desde la terminal dentro del entorno gráfico XFCE:

```bash
code --verbose --disable-gpu-sandbox --no-sandbox
```

## Solución de problemas

### Si VSCode no inicia

Ejecuta en la terminal del contenedor (dentro de XFCE):

```bash
sudo chown -R developer:developer ~/.vscode
```

### Reiniciar servicio VNC

```bash
docker exec dev-box pkill vncserver
docker exec dev-box su - developer -c "vncserver :1"
```

### Problemas de conexión VNC

Verifica que el contenedor está corriendo:

```bash
docker ps -a
```

## Gestión del contenedor

- **Detener contenedor:** `docker stop dev-box`  
- **Iniciar contenedor:** `docker start dev-box`  
- **Eliminar contenedor:** `docker rm -f dev-box`  
- **Acceder a la terminal del contenedor:** `docker exec -it dev-box bash`  

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
  --name dev-box \
  -p 5901:5901 \
  -p 2222:22 \
  -v $(pwd)/tu_codigo:/home/developer/code \
  ubuntu-dev-env
```

3. El flag `--disable-gpu-sandbox` es necesario para VSCode en entornos virtualizados sin soporte completo de sandboxing de GPU.
4. Para mejor rendimiento gráfico, usar calidad de color 24-bit en el cliente VNC.
5. Los archivos de código pueden mapearse usando volúmenes Docker (recomendado para desarrollo real).
