use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :processor, Processor.Endpoint,
  secret_key_base: "AYXeVo2b/laEEq+VR+olwBkqDzhvJwFY/Ay6HvweOcH8Mji7yCbX4NJV9IC9GB86"

# Configure your database
config :processor, Processor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "processor_prod"
