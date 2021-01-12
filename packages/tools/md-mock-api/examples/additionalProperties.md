# Additional properties

## Common

#### Response

```yaml
headers:
  X-Powered-By: "Express"
  Vary: "Origin"
  Access-Control-Allow-Credentials: "true"
  Access-Control-Expose-Headers: "x-ms-request-id,foo-request-id,Content-Type,value,Location,Azure-AsyncOperation,Retry-After"
  Date: { now }
  Connection: "keep-alive"
```

## Routes

### `PUT /additionalProperties/true`

#### Request

##### Body

```json
{
  "birthdate": "2017-12-13T02:29:51Z",
  "complexProperty": { "color": "Red" },
  "id": 1,
  "name": "Puppy"
}
```

#### Response

```yaml
status: 200
headers:
  Header-Just-For-This: value
```

##### Body

```json
{
  "id": 1,
  "name": "Puppy",
  "birthdate": "2017-12-13T02:29:51Z",
  "complexProperty": { "color": "Red" },
  "status": true
}
```
