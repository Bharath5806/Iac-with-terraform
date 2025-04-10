Iac-with-terraform
Provisioning a Docker Container with Terraform

Prerequisites

=>Docker: Installed and running (verify with docker --version).



=>Terraform: Installed (verify with terraform --version).



=>Directory: Create a new folder (e.g mkdir terraform-docker).
Step 1: Create the main.tf File

In our working directory (terraform-docker), create a file named main.tf using a text editor (Notepad).
write the following configuration in main.tf file
# Configure the Docker provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0" 
    }
  }
}

# Docker provider configuration
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Define a Docker image
resource "docker_image" "nginx" {
  name         = "nginx:latest"
}

# Define a Docker container
resource "docker_container" "nginx_container" {
  name  = "nginx-test"
  image = docker_image.nginx.name
  ports {
    internal = 80
    external = 8080 
  }
}

Now save and close the file.

Step 2: Initialize Terraform

Command: Open our terminal in the terraform-docker directory and run:
"terraform init"
this will downloads the Docker provider plugin and initializes the project
  
  =>Expected Execution Log:
 
 Initializing the backend...

Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "~> 3.0"...
- Installing kreuzwerker/docker v3.0.2...
- Installed kreuzwerker/docker v3.0.2 (self-signed, key inattended)

Terraform has been successfully initialized.

Step 3: Plan the Infrastructure

Command: "terraform plan"

This command will generates an execution plan showing what it will create.

=>Expected Execution Log

Terraform will perform the following actions:

  # docker_container.nginx_container will be created
  + resource "docker_container" "nginx_container" {
      + id    = (known after apply)
      + image = "nginx:latest"
      + name  = "nginx-test"
      + ports {
          + external = 8080
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id           = (known after apply)
      + keep_locally = true
      + name         = "nginx:latest"
    }

Plan: 2 to add, 0 to change, 0 to destroy.
This confirms Terraform will create an NGINX image and a container.
Step 4: Apply the Configuration

Command: "terraform apply"
 It will prompts for confirmation, then creates the resources
  
  =>Expected Execution Log:

docker_image.nginx: Creating...
docker_image.nginx: Creation complete after 2s [id=sha256:6b0f7e7b...nginx:latest]
docker_container.nginx_container: Creating...
docker_container.nginx_container: Creation complete after 1s [id=abcd1234...]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Verification:

Run docker ps to see the container:
    CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
abcd1234...    nginx:latest   "/docker-entrypoint...." About a minute ago   Up About a minute   0.0.0.0:8080->80/tcp   nginx-test

Open a browser and visit http://localhost:8080.  we will  see the NGINX welcome page

Step 5: Check Terraform State

Command: "terraform state list"

It will Lists resources managed by Terraform.

=> Expected Execution Log:

docker_container.nginx_container
docker_image.nginx

Step 6: Destroy the Infrastructure

Command: "terraform destroy"
 This command will removes the managed resources after confirmation.

=>Expected Execution Log:

docker_container.nginx_container: Destroying... [id=abcd1234...]
docker_container.nginx_container: Destruction complete after 1s
docker_image.nginx: Destroying... [id=sha256:6b0f7e7b...nginx:latest]
docker_image.nginx: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.

we will get access as
![images](https://github.com/user-attachments/assets/cd9622eb-814a-4860-87c0-d52ffaa950cb)



















































