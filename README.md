# sql

les principals taules són:
```json
users{
  "id":"binary",
  "loginid":"varchar",
  "password":"binary",
  "email":"varchar",
  "fullname":"varchar",
  "description":"varchar"
},

casals{
  "id": "binary",
  "loginid": "varchar",
  "password": "binary",
  "email":"varchar",
  "fullname":"varchar",
  "description":"varchar",
  "valoracion":"",
  "localization":"varchar",
  "latitud":"double",
  "longitud":"double"
},
events{
  "id":"binary",
  "creatorid":"binary",
  "title":"varchar",
  "tipo":"varchar",
  "descripcion":"varchar",
  "valoracion":"varchar",
  "localization":"varchar",
  "latitud":"double",
  "longitud":"double",
  "last_modified":"timestamp",
  "creation_timestamp":"datetime"
},
auth_tokens{
  "userid":"binary",
  "role":"enum"
},
users_events{
  "userid":"binary",
  "eventoid":"binary"
},
comments_casals{
  "id":"binary",
  "creatorid":"binary",
  "casalid":"binary",
  "content":"varchar",
  "creation_timestamp":"datetime"
},
comments_events{
  "id":"binary",
  "creatorid":"binary",
  "eventoid":"binary",
  "content":"varchar",
  "creation_timestamp":"datetime"
}
```
