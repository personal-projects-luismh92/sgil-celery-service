# Variables
VENV_DIR=venv
PYTHON=$(VENV_DIR)/bin/python
PIP=$(VENV_DIR)/bin/pip

# Crear y activar el entorno virtual
venv:
	python3 -m venv $(VENV_DIR)
	$(PIP) install --upgrade pip --extra-index-url https://pypi.org/simple

# Instalar dependencias
install: venv
	$(PIP) install -r requirements.txt --extra-index-url https://pypi.org/simple

# Ejecutar la API en local con recarga automática
run:
	export CELERY_BROKER_URL=redis://redis:6379/0; \
	export CELERY_RESULT_BACKEND=redis://redis:6379/0; \
	export CELERY_ACCEPT_CONTENT=json; \
	export CELERY_TASK_SERIALIZER=json; \
	export LOGGING_SERVICE_URL=http://sgil-monitoreo-service:8090/logs; \
	. $(VENV_DIR)/bin/activate && celery -A celery_worker.celery_config.celery worker --loglevel=info --concurrency=4 -Q email_queue,logging_queue

# Ejecutar pruebas con pytest
test:
	pytest -v

# Formatear código con Black
format:
	black .

# Revisar errores con Flake8
lint:
	flake8 .

# Eliminar el entorno virtual
clean:
	rm -rf $(VENV_DIR) __pycache__

# Regenerar el entorno virtual y reinstalar dependencias
reset: clean venv install

# Ejecutar migraciones con Alembic (si usas migraciones)
migrate:
	alembic upgrade head

# Crear un nuevo archivo de migración (si usas Alembic)
makemigrations:
	alembic revision --autogenerate -m "Nueva migración"
