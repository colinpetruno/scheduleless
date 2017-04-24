# README


## Postgres Installation

Install Postgres. Postgres can be tricky to set up. After installation try
`psql`. If you cannot log in you may need to manage this through the psql user
on the system.

psql -d mydb -U myuser

Once logged in you can run these commands to set up the user in postgres.
`CREATE USER rails WITH PASSWORD 'rails';`
`ALTER USER rails WITH SUPERUSER;`

You can then try running `rails db:create` If this fails you may need to edit 
the pg_hba.conf to allow connections on all users from localhost.
[How to Edit pg_hba.conf](https://www.postgresql.org/docs/9.1/static/auth-pg-hba-conf.html)

## Elasticsearch

`brew install elasticsearch`

If you have existing data run `rake chewy:reset` to ensure that all the data is
loaded into elasticsearch.

Edit the elasticsearch.yml to run the service on port 9201


## oAuth

#### Get an access token:

POST localhost:3000/oauth/token

```json
{
  "grant_type"    : "password",
  "username"      : "demo@example.com",
  "password"      : "password"
}
```

#### Use an access token:

In order to use a token use the authentication header

Authentication: Bearer <TokenGoeshere>

Example Curl:
```
curl -X GET -H "Authorization: Bearer c35042ae39fb1bcad57216eebcafdb6b7addb7ceea5cd99eadf11d2310b48b8d" -H "Cache-Control: no-cache" -H "Postman-Token: 5c9a1329-41c7-2d0a-904d-9e2024a9d61c" "http://localhost:3000/mobile_api/future_shifts"
```
