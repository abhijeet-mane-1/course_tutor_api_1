# Course Tutor API

A RESTful API-only backend built with Ruby on Rails for managing courses and their tutors.

The project demonstrates a clean Rails architecture with JSON:API-compliant responses, ActiveModelSerializers, service objects, request parameter objects, pagination, transactional data creation, centralized API error handling, PostgreSQL constraints, and RSpec test coverage.

---

## Features

- API-only Ruby on Rails application
- RESTful JSON:API endpoints
- Course and Tutor management
- Create a Course with multiple Tutors in a single request
- List Courses with their associated Tutors
- Pagination
- ActiveModelSerializers
- Service Object pattern
- Database transactions
- Centralized API error handling
- RSpec request and model tests
- Shoulda Matchers for model specifications

---

## Tech Stack

| Technology | Version / Usage |
|---|---|
| Ruby | 4.0.5 |
| Rails | 8.1.3 |
| PostgreSQL | 18.4 |
| RSpec | 8.0.4 |
| ActiveModelSerializers | 0.10.16 |
| Bundler | 4.0.10 |
| Git | 2.51.0 |
| API Format | JSON:API |
| Database | PostgreSQL |

---

# Requirements

Make sure the following are installed:

- Ruby 4.0.5
- Rails 8.1.3
- PostgreSQL 18+
- Bundler
- Git

Verify the installation:

```bash
ruby -v
rails -v
bundle -v
psql --version
git --version
```
---

# Setup

Install dependencies
```bash
bundle install
```

Configure the database
- Copy the example database configuration:
```bash
cp config/database.yml.example config/database.yml
```

Create databases
```bash
bin/rails db:create
```

Run migrations
```bash
bin/rails db:migrate
```

Run the test suite
```bash
bundle exec rspec
```

Start the rails server
```bash
bin/rails server
```

---

## API Endpoints

### Create Course

```http
POST /api/v1/courses
Content-Type: application/vnd.api+json
Accept: application/vnd.api+json
```

#### Request

```json
{
  "data": {
    "type": "courses",
    "attributes": { "name": "Ruby on Rails", "description": "Advanced Ruby on Rails course" },
    "relationships": {
      "tutors": {
        "data": [
          { "type": "tutors", "lid": "tutor-1" },
          { "type": "tutors", "lid": "tutor-2" }
        ]
      }
    }
  },
  "included": [
    { "type": "tutors", "lid": "tutor-1", "attributes": { "name": "John Doe", "email": "john@example.com" }},
    { "type": "tutors", "lid": "tutor-2", "attributes": { "name": "Jane Doe", "email": "jane@example.com" }}
  ]
}
```

#### Response

```http
201 Created
Content-Type: application/vnd.api+json
```

```json
{
  "data": {
    "id": "26",
    "type": "courses",
    "attributes": { "name": "Ruby on Rails", "description": "Advanced Ruby on Rails course" },
    "relationships": {
      "tutors": {
        "data": [{ "id": "38", "type": "tutors"}, { "id": "39", "type": "tutors"}]
      }
    }
  },
  "included": [
    { "id": "38", "type": "tutors", "attributes": { "name": "John Doe", "email": "john@example.com" }},
    { "id": "39", "type": "tutors", "attributes": { "name": "Jane Doe", "email": "jane@example.com" }}
  ]
}
```


### List Courses

```http
GET /api/v1/courses?page=1&per_page=10
Accept: application/vnd.api+json
```

#### Response

```json
{
  "data": [
    {
      "id": "26",
      "type": "courses",
      "attributes": { "name": "Ruby on Rails", "description": "Advanced Ruby on Rails course" },
      "relationships": {
        "tutors": {
          "data": [{ "id": "38", "type": "tutors"}, { "id": "39", "type": "tutors"}]
        }
      }
    }
  ],
  "included": [
    { "id": "38", "type": "tutors", "attributes": { "name": "John Doe", "email": "john@example.com" }},
    { "id": "39", "type": "tutors", "attributes": { "name": "Jane Doe", "email": "jane@example.com" }}
  ],
  "meta": {
    "current-page": 1,
    "per-page": 10,
    "total-count": 25,
    "total-pages": 3
  }
}
```

---

## Error Responses

The API returns errors using the JSON:API error object format.

### Validation Error

```http
422 Unprocessable Content
Content-Type: application/vnd.api+json
```

```json
{
  "errors": [
    {
      "status": "422",
      "code": "VALIDATION_ERROR",
      "detail": "Email has already been taken"
    }
  ]
}
```

### Invalid Request

```http
400 Bad Request
Content-Type: application/vnd.api+json
```

```json
{
  "errors": [
    {
      "status": "400",
      "code": "BAD_REQUEST",
      "detail": "Invalid resource type"
    }
  ]
}
```

---

### Architecture

The application follows a layered API architecture:

```text
HTTP Request
     |
     v
CoursesController
     |
     +----------------------+
     |                      |
     v                      v
CourseCreateParams     Pagination
     |
     v
CourseCreateService
     |
     v
ActiveRecord
     |
     v
PostgreSQL
     |
     v
ActiveModelSerializers
     |
     v
JSON:API Response
```
