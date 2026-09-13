# MyApp Blog API - Thunder Client

## Base URL

```text
http://localhost:8000
```

## Endpoints

### 1. GET /api/categories

```http
GET http://localhost:8000/api/categories
```

Response body:

```json
{
  "message": "berhasil fetch categories",
  "data": [
    {
      "id": 1,
      "name": "Technology"
    }
  ]
}
```

### 2. GET /api/posts

```http
GET http://localhost:8000/api/posts
```

Response body:

```json
{
  "message": "berhasil fetch posts",
  "data": [
    {
      "id": 1,
      "title": "New Post",
      "content": "This is the post content",
      "category_id": 1
    }
  ]
}
```

### 3. GET /api/posts/:id

```http
GET http://localhost:8000/api/posts/1
```

Response body:

```json
{
  "message": "berhasil fetch post",
  "data": {
    "id": 1,
    "title": "New Post",
    "content": "This is the post content",
    "category_id": 1
  }
}
```

### 4. POST /api/posts

```http
POST http://localhost:8000/api/posts
Content-Type: application/json
```

Request body:

```json
{
  "title": "New Post",
  "content": "This is the post content",
  "category_id": 1
}
```

Response body:

```json
{
  "message": "berhasil menambahkan post",
  "data": {
    "id": 1,
    "title": "New Post",
    "content": "This is the post content",
    "category_id": 1
  }
}
```

### 5. PUT /api/posts/:id

```http
PUT http://localhost:8000/api/posts/1
Content-Type: application/json
```

Request body:

```json
{
  "title": "Updated Post Title"
}
```

Response body:

```json
{
  "message": "berhasil update post",
  "data": {
    "title": "Updated Post Title"
  }
}
```

### 6. DELETE /api/posts/:id

```http
DELETE http://localhost:8000/api/posts/1
```

Response body:

```json
{
  "message": "berhasil menghapus post"
}
```
