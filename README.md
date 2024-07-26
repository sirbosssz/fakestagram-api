# Fakestagram API

This is project that mimic of Instagram in MVP feature (post image and descriptions)

# Setup

1. Install docker

2. Clone the project and run following command

```sh
docker compose up --build -d
```

3. That should be able to run in `localhost:3000`

# API Lists

Assuming using Postman to run APIs

> you can import `Fakestagram API.postman_collection` in Postman to run following APIs

### Header Setup

> if any API that require authentication, should do the following.
1. Login with [Login-API](#Setup)

2. You will get response like this

```json
{
    "result": {
        "username": "example",
        "jwt": "eyJhbGciOiJIUzI1NiJ9....."
    }
}
```

3. Copy jwt value from response

4. Go to __Authorization__ tab in Postman

5. Select Auth Type to `Bearer Token`

6. Paste value to __Token__ field

## Auth

### Login

- Method: POST
- URL: `http://localhost:3000/api/auth/login`
- Require Body:
  - email: string
  - password: string
- Response:
  - result
    - username: string
    - jwt: string

### Register

- Method: POST
- URL: `http://localhost:3000/api/register`
- Require Body:
  - email: string
  - password: string
  - username: string
- Response:
  - status: int
  - result: User

### CheckToken

- Method: GET
- URL: `http://localhost:3000/api/register`
- Require Headers:
  - Authorization: Bearer <jwt>
- Response:
  - message: string

### Logout

- Method: DELETE
- URL: `http://localhost:3000/api/auth/logout`
- Require Headers:
  - Authorization: Bearer <jwt>
- Response:
  - message: string

## Post

### Get All

- Method: GET
- URL: `http://localhost:3000/api/posts`
- Response:
  - Post[]

### Get My

- Method: GET
- URL: `http://localhost:3000/api/posts/my`
- Require Headers:
  - Authorization: Bearer <jwt>
- Response:
  - Post[]

### Create

- Method: POST
- URL: `http://localhost:3000/api/posts`
- Require Headers:
  - Authorization: Bearer <jwt>
- Require Body:
  - image_url: string
  - description: string
- Response:
  - Post

### Get By Id

- Method: GET
- URL: `http://localhost:3000/api/posts/:id`
- Params
  - id: int
- Response:
  - Post

### Edit

- Method: PATCH
- URL: `http://localhost:3000/api/posts/:id`
- Params
  - id: int
- Require Headers:
  - Authorization: Bearer <jwt>
- Require Body:
  - image_url: string
  - description: string
- Response:
  - Post

### Delete

- Method: DELETE
- URL: `http://localhost:3000/api/posts/:id`
- Params
  - id: int
- Require Headers:
  - Authorization: Bearer <jwt>
- Response:
  - message: string