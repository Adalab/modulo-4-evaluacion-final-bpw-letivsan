// IMPORTS
const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise'); // Importar la biblioteca de MySQL
require('dotenv').config(); // Importamos la biblioteca de variables de entorno

// ========================================
// CONFIGURACIÓN BASE DE DATOS

const getConnection = async () => {
  const connectionData = {
    host: process.env.MYSQL_HOST || 'localhost',
    port: process.env.MYSQL_PORT || 3306,
    user: process.env.MYSQL_USER || 'root',
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_SCHEMA || 'leagueoflegends',
  };

  const connection = await mysql.createConnection(connectionData);
  await connection.connect();
  return connection;
};

// ========================================
// CONFIGURACIÓN EXPRESS

const server = express();

// Configuración para que sea un API RESTful
server.use(cors()); // API pública
server.use(express.json({ limit: '25Mb' }));

// ARRANCAR EXPRESS
const port = process.env.PORT || 3000;

server.listen(port, () => {
  console.log(`El servidor se ha arrancado en http://localhost:${port}/`);
});

// ========================================
// CONFIGURACIÓN AUTENTICACIÓN

// ========================================
// ENDPOINTS
server.get('/', (req, res) => {
  res.send('API League of Legends funcionando');
});

// Endpoint temporal solo para probar la conexión con MySQL
server.get('/api/test-db', async (req, res) => {
  let connection;

  try {
    connection = await getConnection();

    res.json({
      success: true,
      message: 'Conexión con MySQL correcta',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  } finally {
    if (connection) {
      await connection.end();
    }
  }
});

// GET /api/champions
server.get('/api/champions', async (req, res) => {
  let connection;

  try {
    // 1. Nos conectamos con la bbdd
    connection = await getConnection();

    // 2. Preparamos una query = SELECT
    const queryListarChampions = `
      SELECT *
      FROM champions
      ORDER BY name;
    `;

    // 3. Lanzamos la query y nos quedamos con los resultados
    const [resultados] = await connection.query(queryListarChampions);

    // 4. Respondemos con los datos
    res.json(resultados);
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  } finally {
    // 5. Cerramos la conexión
    if (connection) {
      await connection.end();
    }
  }
});

// GET /api/champions/:id
server.get('/api/champions/:id', async (req, res) => {
  if (isNaN(parseInt(req.params.id))) {
    return res.status(400).json({
      success: false,
      error: 'El id no es un número.',
    });
  }

  let connection;

  try {
    // 1. Nos conectamos con la bbdd
    connection = await getConnection();

    // 2. Preparamos una query = SELECT
    const queryObtenerChampion = `
      SELECT *
      FROM champions
      WHERE id = ?;
    `;

    // 3. Lanzamos la query y nos quedamos con los resultados
    const [resultados] = await connection.query(queryObtenerChampion, [
      req.params.id,
    ]);

    // 4. Respondemos con los datos
    if (resultados.length === 1) {
      res.json(resultados[0]);
    } else {
      res.status(404).json({
        success: false,
        error: 'No existe ningún campeón con ese id.',
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  } finally {
    // 5. Cerramos la conexión
    if (connection) {
      await connection.end();
    }
  }
});

// POST /api/champions
server.post('/api/champions', async (req, res) => {
  if (
    !req.body.riot_id ||
    req.body.riot_key === undefined ||
    !req.body.name ||
    !req.body.title
  ) {
    return res.status(400).json({
      success: false,
      error: 'Faltan datos obligatorios.',
    });
  }

  let connection;

  try {
    // 1. Nos conectamos con la bbdd
    connection = await getConnection();

    // 2. Preparamos una sentencia = INSERT
    const sentenciaInsertChampion = `
      INSERT INTO champions (
        riot_id,
        riot_key,
        name,
        title,
        region_id,
        resource,
        attack,
        defense,
        magic,
        difficulty,
        lore_summary,
        image_url,
        created_at,
        updated_at
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW());
    `;

    // 3. Lanzamos la sentencia y nos quedamos con los resultados
    const [resultadoInsert] = await connection.execute(
      sentenciaInsertChampion,
      [
        req.body.riot_id,
        req.body.riot_key,
        req.body.name,
        req.body.title,
        req.body.region_id ?? null,
        req.body.resource ?? null,
        req.body.attack ?? null,
        req.body.defense ?? null,
        req.body.magic ?? null,
        req.body.difficulty ?? null,
        req.body.lore_summary ?? null,
        req.body.image_url ?? null,
      ],
    );

    // 4. Respondemos con los datos
    if (resultadoInsert.affectedRows === 1) {
      res.json({
        success: true,
        data: {
          id: resultadoInsert.insertId,
          ...req.body,
        },
      });
    } else {
      res.json({ success: false });
    }
  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      return res.status(400).json({
        success: false,
        error: 'Ya existe un campeón con ese riot_id, riot_key o name.',
      });
    }

    if (error.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({
        success: false,
        error: 'La región indicada no existe.',
      });
    }

    res.status(500).json({
      success: false,
      error: error.message,
    });
  } finally {
    // 5. Cerramos la conexión
    if (connection) {
      await connection.end();
    }
  }
});

// PUT /api/champions/:id
server.put('/api/champions/:id', async (req, res) => {
  if (isNaN(parseInt(req.params.id))) {
    return res.status(400).json({
      success: false,
      error: 'El id no es un número.',
    });
  }

  if (
    !req.body.riot_id ||
    req.body.riot_key === undefined ||
    !req.body.name ||
    !req.body.title
  ) {
    return res.status(400).json({
      success: false,
      error: 'Faltan datos obligatorios.',
    });
  }

  let connection;

  try {
    // 1. Nos conectamos con la bbdd
    connection = await getConnection();

    // 2. Preparamos una sentencia = UPDATE
    const sentenciaUpdateChampion = `
      UPDATE champions
      SET
        riot_id = ?,
        riot_key = ?,
        name = ?,
        title = ?,
        region_id = ?,
        resource = ?,
        attack = ?,
        defense = ?,
        magic = ?,
        difficulty = ?,
        lore_summary = ?,
        image_url = ?,
        updated_at = NOW()
      WHERE id = ?;
    `;

    // 3. Lanzamos la sentencia y nos quedamos con los resultados
    const [resultadoUpdate] = await connection.execute(
      sentenciaUpdateChampion,
      [
        req.body.riot_id,
        req.body.riot_key,
        req.body.name,
        req.body.title,
        req.body.region_id ?? null,
        req.body.resource ?? null,
        req.body.attack ?? null,
        req.body.defense ?? null,
        req.body.magic ?? null,
        req.body.difficulty ?? null,
        req.body.lore_summary ?? null,
        req.body.image_url ?? null,
        req.params.id,
      ],
    );

    // 4. Respondemos con los datos
    if (resultadoUpdate.affectedRows === 1) {
      res.json({
        success: true,
        data: {
          id: req.params.id,
          ...req.body,
        },
      });
    } else {
      res.status(404).json({
        success: false,
        error: 'No existe ningún campeón con ese id.',
      });
    }
  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      return res.status(400).json({
        success: false,
        error: 'Ya existe un campeón con ese riot_id, riot_key o name.',
      });
    }

    if (error.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({
        success: false,
        error: 'La región indicada no existe.',
      });
    }

    res.status(500).json({
      success: false,
      error: error.message,
    });
  } finally {
    // 5. Cerramos la conexión
    if (connection) {
      await connection.end();
    }
  }
});

// DELETE /api/champions/:id
server.delete('/api/champions/:id', async (req, res) => {
  const championId = parseInt(req.params.id);

  if (isNaN(championId)) {
    return res.status(400).json({
      success: false,
      error: 'El id debe ser un número.',
    });
  }

  let connection;

  try {
    connection = await getConnection();

    const queryDeleteChampion = `
    DELETE FROM champions
    WHERE id = ?;
    `;

    const [resultDelete] = await connection.execute(queryDeleteChampion, [
      championId,
    ]);

    if (resultDelete.affectedRows === 1) {
      res.json({
        success: true,
        message: 'Campeón eliminado satisfactoriamente.',
      });
    } else {
      res.status(404).json({
        success: false,
        error: 'No se encuentra el campeón.',
      });
    }
  } catch (error) {
    if (error.code === 'ER_ROW_IS_REFERENCED_2') {
      return res.status(400).json({
        success: false,
        error:
          'No se puede eliminar este campeón porque tiene datos relacionados.',
      });
    }

    res.status(500).json({
      success: false,
      error: error.message,
    });
  } finally {
    if (connection) {
      await connection.end();
    }
  }
});

// // Páginas dinámicas
// // Ficheros estáticos
