 terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}
provider "docker" {
  host = "unix:///var/run/docker.sock"
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
 }
}
resource "docker_container" "nginx_container" {
  name  = "nginx-terraform"
  image = docker_image.nginx.name

  ports {
    internal = 80
    external = 8080
  }
}
