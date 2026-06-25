# League of Legends API

API REST desarrollada con Node.js, Express y MySQL para gestionar información de campeones de League of Legends.

La entidad principal del CRUD es `champions`.

## Motivación del proyecto

Este proyecto forma parte de la evaluación final del Módulo 4 de Adalab. El objetivo ha sido practicar la creación de una API REST desde cero, conectando un servidor Express con una base de datos MySQL.

Elegí el universo de League of Legends porque permite trabajar con una temática amplia, con entidades relacionadas como campeones, regiones, habilidades, clases y posiciones. Además, es un contexto útil para practicar estructuras de datos reales y relaciones entre tablas.

## Tecnologías utilizadas

- Node.js
- Express.js
- MySQL
- mysql2/promise
- cors
- dotenv
- bcrypt
- jsonwebtoken
- Postman
- MySQL Workbench

## Estructura del proyecto

```txt
.
├── data/
│   ├── apileagueoflegends.mwb
│   ├── apileagueoflegends.sql
│   └── leagueoflegends_usuarios_db.sql
│
├── postman/
│   ├── League of Legends API.postman_collection.json
│   └── League of legends local.postman_environment.json
│
├── src/
│   └── index.js
│
├── .env.example
├── .gitignore
├── package-lock.json
├── package.json
└── README.md
```

> Nota: Las carpetas `node_modules` y el archivo `.env` no se incluyen en el repositorio. `node_modules` se genera al instalar dependencias y `.env` contiene datos privados de conexión y claves secretas. El archivo `.env.example` sirve como referencia para crear la configuración local.

## Instalación

Clonar el repositorio:

```bash
git clone https://github.com/Adalab/modulo-4-evaluacion-final-bpw-letivsan.git
```

Entrar en la carpeta del proyecto:

```bash
cd modulo-4-evaluacion-final-bpw-letivsan
```

Instalar las dependencias:

```bash
npm install
```

## Configuración de variables de entorno

El proyecto utiliza variables de entorno para configurar la conexión con MySQL, el puerto del servidor y la autenticación con JWT.

Crear un archivo `.env` en la raíz del proyecto tomando como referencia el archivo `.env.example`.

Ejemplo:

```env
PORT=3000
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=tu_contraseña
MYSQL_SCHEMA=leagueoflegends

SALT_ROUNDS=10
PASSWORD_JWT=tu_clave_secreta_para_jwt
```

El archivo `.env` no debe subirse al repositorio porque contiene datos privados de conexión y la clave secreta usada para firmar los tokens JWT.

## Base de datos

El diseño de la base de datos está guardado en la carpeta `data`.

Archivos incluidos:

```txt
data/apileagueoflegends.mwb
data/apileagueoflegends.sql
data/leagueoflegends_usuarios_db.sql
```

Para importar la base de datos:

1. Abrir MySQL Workbench.
2. Ejecutar el archivo `data/apileagueoflegends.sql`.
3. Ejecutar el archivo `data/leagueoflegends_usuarios_db.sql`.
4. Comprobar que se ha creado el schema `leagueoflegends`.

La base de datos contiene las siguientes tablas:

- regions
- champions
- abilities
- champion_classes
- lanes
- champion_classifications
- champion_positions
- usuarios_db

## Scripts disponibles

Arrancar el servidor:

```bash
npm start
```

Arrancar el servidor en modo desarrollo:

```bash
npm run dev
```

El servidor se inicia por defecto en:

```txt
http://localhost:3000
```

## Endpoints generales

### Comprobar que el servidor funciona

```http
GET /
```

Respuesta esperada:

```txt
API League of Legends funcionando
```

### Comprobar conexión con MySQL

```http
GET /api/test-db
```

Respuesta esperada:

```json
{
  "success": true,
  "message": "Conexión con MySQL correcta"
}
```

## Autenticación JWT

El proyecto incluye un bonus de autenticación con JWT.

Se han añadido dos endpoints públicos para gestionar usuarias:

```http
POST /api/registro
POST /api/login
```

Las contraseñas se cifran con `bcrypt` antes de guardarse en la base de datos. Si el registro o el login son correctos, el servidor devuelve un token JWT.

### Registro de usuaria

```http
POST /api/registro
```

Body de ejemplo:

```json
{
  "nombre": "Senna",
  "user": "senna@correo.com",
  "pass": "tucontraseña"
}
```

Respuesta esperada:

```json
{
  "success": true,
  "token": "jwt_token"
}
```

Si faltan datos obligatorios, devuelve un error:

```json
{
  "success": false,
  "error": "Faltan datos para el registro."
}
```

### Login de usuaria

```http
POST /api/login
```

Body de ejemplo:

```json
{
  "user": "senna@correo.com",
  "pass": "tucontraseña"
}
```

Respuesta esperada:

```json
{
  "success": true,
  "token": "jwt_token"
}
```

Si las credenciales no son correctas, devuelve un error:

```json
{
  "success": false,
  "error": "Credenciales no válidas."
}
```

### Uso del token

Los endpoints protegidos requieren enviar el token en la autorización de tipo Bearer Token:

```txt
Authorization: Bearer jwt_token
```

En Postman se utiliza la variable `TOKEN` para guardar temporalmente el token devuelto por `POST /api/registro` o `POST /api/login`.

## Champions

### Listar todos los campeones

```http
GET /api/champions
```

Devuelve un array con todos los campeones ordenados por nombre.

### Obtener un campeón por id

```http
GET /api/champions/:id
```

Ejemplo:

```http
GET /api/champions/1
```

Respuesta esperada:

```json
{
  "id": 1,
  "riot_id": "Ahri",
  "riot_key": 103,
  "name": "Ahri",
  "title": "the Nine-Tailed Fox",
  "region_id": 1,
  "resource": "Mana",
  "attack": 3,
  "defense": 4,
  "magic": 8,
  "difficulty": 5,
  "lore_summary": "...",
  "image_url": "...",
  "created_at": "...",
  "updated_at": "..."
}
```

Si el id no es un número, devuelve un error 400:

```json
{
  "success": false,
  "error": "El id no es un número."
}
```

Si no existe ningún campeón con ese id, devuelve un error 404:

```json
{
  "success": false,
  "error": "No existe ningún campeón con ese id."
}
```

### Crear un campeón

```http
POST /api/champions
```

Este endpoint requiere autenticación mediante Bearer Token.

Body de ejemplo:

```json
{
  "riot_id": "Ezreal",
  "riot_key": 81,
  "name": "Ezreal",
  "title": "the Prodigal Explorer",
  "region_id": 2,
  "resource": "Mana",
  "attack": 6,
  "defense": 2,
  "magic": 7,
  "difficulty": 5,
  "lore_summary": "Ezreal is an explorer with a magical gauntlet.",
  "image_url": "https://example.com/ezreal.png"
}
```

Respuesta esperada:

```json
{
  "success": true,
  "data": {
    "id": 9,
    "riot_id": "Ezreal",
    "riot_key": 81,
    "name": "Ezreal",
    "title": "the Prodigal Explorer",
    "region_id": 2,
    "resource": "Mana",
    "attack": 6,
    "defense": 2,
    "magic": 7,
    "difficulty": 5,
    "lore_summary": "Ezreal is an explorer with a magical gauntlet.",
    "image_url": "https://example.com/ezreal.png"
  }
}
```

Los campos obligatorios para crear un campeón son:

- riot_id
- riot_key
- name
- title

Si no se envía token, devuelve un error 401:

```json
{
  "success": false,
  "error": "Falta el token."
}
```

Si el token no es válido, devuelve un error 401:

```json
{
  "success": false,
  "error": "Token no válido."
}
```

Si faltan datos obligatorios, devuelve un error 400.

Si ya existe un campeón con el mismo `riot_id`, `riot_key` o `name`, devuelve un error 400.

Si la región indicada no existe, devuelve un error 400.

### Actualizar un campeón

```http
PUT /api/champions/:id
```

Este endpoint requiere autenticación mediante Bearer Token.

Ejemplo:

```http
PUT /api/champions/9
```

Body de ejemplo:

```json
{
  "riot_id": "Ezreal",
  "riot_key": 81,
  "name": "Ezreal",
  "title": "the Prodigal Explorer",
  "region_id": 2,
  "resource": "Mana",
  "attack": 6,
  "defense": 2,
  "magic": 7,
  "difficulty": 6,
  "lore_summary": "Ezreal is an explorer with a magical gauntlet.",
  "image_url": "https://example.com/ezreal.png"
}
```

Respuesta esperada:

```json
{
  "success": true,
  "data": {
    "id": "9",
    "riot_id": "Ezreal",
    "riot_key": 81,
    "name": "Ezreal",
    "title": "the Prodigal Explorer",
    "region_id": 2,
    "resource": "Mana",
    "attack": 6,
    "defense": 2,
    "magic": 7,
    "difficulty": 6,
    "lore_summary": "Ezreal is an explorer with a magical gauntlet.",
    "image_url": "https://example.com/ezreal.png"
  }
}
```

Los campos obligatorios para actualizar un campeón son:

- riot_id
- riot_key
- name
- title

Si el id no es un número, devuelve un error 400.

Si faltan datos obligatorios, devuelve un error 400.

Si no existe ningún campeón con ese id, devuelve un error 404.

Si ya existe un campeón con el mismo `riot_id`, `riot_key` o `name`, devuelve un error 400.

Si la región indicada no existe, devuelve un error 400.

### Eliminar un campeón

```http
DELETE /api/champions/:id
```

Este endpoint requiere autenticación mediante Bearer Token.

Ejemplo:

```http
DELETE /api/champions/9
```

Respuesta esperada:

```json
{
  "success": true,
  "message": "Campeón eliminado satisfactoriamente."
}
```

Si el id no es un número, devuelve un error 400:

```json
{
  "success": false,
  "error": "El id debe ser un número."
}
```

Si el id no existe, devuelve un error 404:

```json
{
  "success": false,
  "error": "No se encuentra el campeón."
}
```

Si el campeón tiene datos relacionados en otras tablas, devuelve un error 400:

```json
{
  "success": false,
  "error": "No se puede eliminar este campeón porque tiene datos relacionados."
}
```

## Colección de Postman

La API se ha probado con una colección de Postman llamada:

```txt
League of Legends API
```

Los archivos exportados se encuentran en:

```txt
postman/League of Legends API.postman_collection.json
postman/League of legends local.postman_environment.json
```

La colección utiliza estas variables:

```txt
HOST=http://localhost:3000
TOKEN=
```

La variable `TOKEN` debe rellenarse con el token devuelto por `POST /api/registro` o `POST /api/login`.

Requests principales incluidas en la colección:

- GET root
- GET test DB
- GET champions
- GET champion by id
- GET champion error id
- POST auth register user
- POST auth login user
- POST champions and create
- PUT update champion
- GET updated champion
- DELETE delete champion
- GET deleted champion
- DELETE champion error id
- DELETE champion not found

## Bonus realizados

Además del CRUD principal, se han añadido los siguientes bonus o mejoras:

- Autenticación con JWT.
- Registro de usuarias.
- Login de usuarias.
- Contraseñas cifradas con bcrypt.
- Protección de endpoints de creación, actualización y eliminación.
- Colección de pruebas exportada desde Postman.
- Uso de variables de entorno con dotenv.

No se ha incluido despliegue online, frontend estático, Swagger ni tests automatizados con Jest/Supertest.

## Qué he aprendido

Con este proyecto he practicado:

- Crear una base de datos relacional con MySQL Workbench.
- Exportar el modelo y el script SQL de una base de datos.
- Crear un servidor con Express.
- Conectar Express con MySQL usando `mysql2/promise`.
- Configurar variables de entorno con `dotenv`.
- Crear endpoints REST con métodos GET, POST, PUT y DELETE.
- Validar datos recibidos por URL params y body params.
- Probar una API con Postman.
- Gestionar errores básicos del servidor y de la base de datos.
- Cifrar contraseñas con bcrypt.
- Generar y verificar tokens JWT.
- Proteger endpoints mediante Bearer Token.
- Organizar un proyecto backend de forma clara.

## Agradecimientos y fuentes

Los datos y nombres utilizados están inspirados en el universo de League of Legends.

Para completar información de campeones se ha tomado como referencia Riot Games Data Dragon, también conocido como DDragon.

Este proyecto tiene finalidad educativa y no comercial.

## Autora

Proyecto realizado por Leticia Viéitez como evaluación final del Módulo 4 de Adalab.
