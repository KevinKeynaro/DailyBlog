import express from 'express';
import cors from "cors";
import pool from "./config/database.js";
import * as z from "zod";

const app = express();
const port = 8000;

app.use(express.json())
app.use(cors())

app.get('/', (req, res) => {
  res.json({
    message: "test"
  })
})

const createArticleSchema = z.object({
  title: z.string().min(1, "title is required"),
  content: z.string().min(1, "content is required"),
  category_id: z.number().int().positive("category_id is required"),
});

const updateArticleSchema = z.object({
  title: z.string().min(1).optional(),
  content: z.string().min(1).optional(),
  category_id: z.number().int().positive().optional(),
});

// GET all categories
app.get('/api/categories', async (req, res) => {
  try {
    const [rows] = await pool.query("select * from categories order by id asc");
    res.status(200).json({
      message: "berhasil fetch categories",
      data: rows
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "gagal fetch categories",
      error: error.message
    });
  }
});

// ==================== ARTICLES ====================

// GET all articles (join dengan categories supaya nama kategori ikut tampil)
app.get('/api/articles', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `select article.id, article.title, article.content, article.category_id,
      categories.name as category, article.created_at, article.updated_at
      from article
      join categories on article.category_id = categories.id
      order by article.id asc`
    );
    res.status(200).json({
      message: "berhasil fetch articles",
      data: rows
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "gagal fetch articles",
      error: error.message
    });
  }
});

// GET single article by id
app.get('/api/articles/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `select article.id, article.title, article.content, article.category_id,
              categories.name as category, article.created_at, article.updated_at
       from article
       join categories on article.category_id = categories.id
       where article.id = ?`,
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: "article tidak ditemukan"
      });
    }

    res.status(200).json({
      message: "berhasil fetch article",
      data: rows[0]
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "gagal fetch article",
      error: error.message
    });
  }
});

// POST create new article
app.post('/api/articles', async (req, res) => {
  const result = createArticleSchema.safeParse(req.body);

  if (!result.success) {
    return res.status(400).json({
      message: "validasi gagal",
      errors: result.error.issues
    });
  }

  const { title, content, category_id } = result.data;

  try {
    const [insertResult] = await pool.query(
      "insert into article (title, content, category_id) values (?, ?, ?)",
      [title, content, category_id]
    );

    res.status(201).json({
      message: "berhasil menambahkan article",
      data: {
        id: insertResult.insertId,
        title,
        content,
        category_id,
      }
    });
  } catch (error) {
    console.error(error);
    // error code saat category_id yang dikirim tidak ada di tabel categories
    if (error.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({
        message: "category_id tidak valid / tidak ditemukan"
      });
    }
    res.status(500).json({
      message: "gagal menambahkan article",
      error: error.message
    });
  }
});

// PUT update article by id
app.put('/api/articles/:id', async (req, res) => {
  const result = updateArticleSchema.safeParse(req.body);

  if (!result.success) {
    return res.status(400).json({
      message: "validasi gagal",
      errors: result.error.issues
    });
  }

  const fields = Object.keys(result.data);

  if (fields.length === 0) {
    return res.status(400).json({
      message: "tidak ada data untuk diupdate"
    });
  }

  const setClause = fields.map((field) => `${field} = ?`).join(", ");
  const values = fields.map((field) => result.data[field]);

  try {
    const [updateResult] = await pool.query(
      `update article set ${setClause} where id = ?`,
      [...values, req.params.id]
    );

    if (updateResult.affectedRows === 0) {
      return res.status(404).json({
        message: "article tidak ditemukan"
      });
    }

    res.status(200).json({
      message: "berhasil update article",
      data: result.data
    });
  } catch (error) {
    console.error(error);
    if (error.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({
        message: "category_id tidak valid / tidak ditemukan"
      });
    }
    res.status(500).json({
      message: "gagal update article",
      error: error.message
    });
  }
});

// DELETE article by id
app.delete('/api/articles/:id', async (req, res) => {
  try {
    const [deleteResult] = await pool.query("delete from article where id = ?", [req.params.id]);

    if (deleteResult.affectedRows === 0) {
      return res.status(404).json({
        message: "article tidak ditemukan"
      });
    }

    res.status(200).json({
      message: "berhasil menghapus article"
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "gagal menghapus article"
    });
  }
});


app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});