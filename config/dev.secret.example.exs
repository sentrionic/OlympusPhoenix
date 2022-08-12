import Config

config :olympus_blog, OlympusBlog.Repo,
  username: "root",
  password: "password",
  hostname: "localhost",
  database: "olympus_phoenix",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :redis_config,
  redisUrl: "localhost/6379"

config :ex_aws,
  access_key_id: "",
  secret_access_key: "",
  s3: [
    scheme: "https://",
    region: ""
  ],
  bucket: "",
  region: ""
