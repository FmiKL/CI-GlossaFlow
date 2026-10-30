terraform {
  required_version = "~> 1.17.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.6.0"
    }
  }

  backend "local" {}
}

variable "prefix" {
  type    = string
  default = "glossaflow-local"
}

variable "secrets_dir" {
  type = string
}

variable "api_image_id" {
  type = string
}

resource "docker_network" "app" {
  name = var.prefix
}

resource "docker_volume" "postgres" {
  name = "${var.prefix}-postgres-data"
}

resource "docker_image" "postgres" {
  name         = "postgres:17.11-bookworm@sha256:858bb5e98eed02eb8cafbcdc007f9a65d1b613972028944a8ec2133ccaf80d27"
  keep_locally = true
}

resource "docker_container" "postgres" {
  name  = "${var.prefix}-postgres"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=glossaflow_demo",
    "POSTGRES_PASSWORD_FILE=/run/secrets/pg_admin_password",
  ]

  networks_advanced {
    name = docker_network.app.name
  }

  volumes {
    volume_name    = docker_volume.postgres.name
    container_path = "/var/lib/postgresql/data"
  }

  volumes {
    host_path      = abspath("${path.module}/postgres")
    container_path = "/opt/glossaflow"
    read_only      = true
  }

  volumes {
    host_path      = abspath("${path.module}/postgres/init.sh")
    container_path = "/docker-entrypoint-initdb.d/init.sh"
    read_only      = true
  }

  volumes {
    host_path      = "${var.secrets_dir}/pg_admin_password"
    container_path = "/run/secrets/pg_admin_password"
    read_only      = true
  }

  volumes {
    host_path      = "${var.secrets_dir}/pg_app_password"
    container_path = "/run/secrets/pg_app_password"
    read_only      = true
  }
}

resource "docker_container" "api" {
  name  = "${var.prefix}-api"
  image = var.api_image_id

  env = [
    "PGHOST=${docker_container.postgres.name}",
    "PGDATABASE=glossaflow_demo",
    "PGUSER=glossaflow_app",
    "DB_PASSWORD_FILE=/run/secrets/pg_app_password",
  ]

  networks_advanced {
    name = docker_network.app.name
  }

  volumes {
    host_path      = "${var.secrets_dir}/pg_app_password"
    container_path = "/run/secrets/pg_app_password"
    read_only      = true
  }

  ports {
    internal = 3000
    external = 8080
    ip       = "127.0.0.1"
  }
}
