```
/sgil-celery-service  
  ├── tasks/  
  │   ├── __init__.py  
  │   ├── email_tasks.py  # Tareas de correos  
  │   ├── logging_tasks.py  # Tareas de logging  
  ├── celery_app.py  # Configuración de Celery  
  ├── Dockerfile  
  ├── requirements.txt  
  ├── docker-compose.yml
```


## Docker compose

> ⚠️ **IMPORTANTE:** Antes de ejecutar los contenedores con Docker Compose, asegúrate de crear manualmente la red `sgil_network` con:
> 
> ```sh
> docker network create sgil_network
> ```

### 🚀 Ejecutar el proyecto desde docker-compose
```
docker-compose -f docker-compose.local.yml up --build
```

### Eliminar volúmenes y contenedores antiguos 
```
docker system prune
```

### Eliminar los contennedores & volumenes
```
docker-compose down -v
```