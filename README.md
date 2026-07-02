# COSC2759 Assignment 2 - Semester 2, 2025
_Coursework for **Systems Deployment and Operations** (RMIT-COSC2759)_

# Services

## Backend
This is the Backend Posts Service. It is responsible for talking to the Posts DB, and exposing an internal HTTP API for managing Posts.

### Environment Variables
| Environment Variable | Purpose                                                 |
|----------------------|---------------------------------------------------------|
| PORT                 | Which port will the service listen on for HTTP requests |
| DB_USER              | Username for connecting to the Backend DB               |
| DB_PASSWORD          | Password for connecting to the Backend DB               |
| DB_HOST              | Hostname/Network address for the Backend DB             |

### Image
The Backend service image is available at `rmitdominichynes/sdo-2025:backend`.

### Dependencies
The Backend service depends on a PostgreSQL database, with the required migrations. An image for this has been provided, available at `rmitdominichynes/sdo-2025:db`.

### Database Configuration
The PostgreSQL Databse container also requires some environment variables to be configured.

|  Environment Variable        |  Purpose                                                  |
|------------------------------|-----------------------------------------------------------|
|  POSTGRES_USER               | Username for the Backend Service to use to connect        |
|  POSTGRES_PASSWORD           | Password for the Backend Service to use to connect        |
|  POSTGRES_DB                 | "posts"                                                   |

## Frontend
This is the Frontend Posts Service. It is responsible for serving a UI to users over HTTP. This UI allows them to view and manage Posts.

### Environment Variables
| Environment Variable | Purpose                                                 |
|----------------------|---------------------------------------------------------|
| PORT                 | Which port will the service listen on for HTTP requests |
| BACKEND_URL          | Fully qualified URL for reaching the Backend Service    |

### Image
The Frontend service image is available at `rmitdominichynes/sdo-2025:frontend`.

# Local Deployment in Docker Desktop

1. Run `docker compose up -d` to start the two services, and a postgres database container.
2. View the Frontend Posts Service at `http://localhost:8081`, and the Backend Posts Service at `http://localhost:8080`.

## Services Deployment on AWS EC2

This repository is designed to work on WSL Ubuntu (or any other native Linux distributions).

### Configurations

1. Install Terraform and Ansible on the WSL environment:

`sudo snap install terraform --classic`

`sudo apt install ansible`

2. Run `ssh-keygen -f ~/.ssh/aws_ssh -t ed25519` to generate a key pair at `~/.ssh` depending on your WSL environment. To simplify the deployment process in later steps, it is recommended to generate the key pair without any passphrase.

3. Set the correct AWS configs and credentials in the `.aws` folder depending on the local environment.

### Deployment

To deploy the defined infrastructure, run `bash deploy.sh` in the repository's root directory.

To terminate them afterwards, run `bash destroy.sh` in the same directory.

## Deploying from GitHub Actions

All steps have been defined in the `deploy.yml` workflow file; however, for every AWS sessions, define or update the secrets `ACCESS_KEY_ID`, `SECRET_ACCESS_KEY` and `SESSION_TOKEN` in GitHub Secrets with their respective correct values.
