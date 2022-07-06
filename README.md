# Fullstack boilerplate BlueBlazer

## Monorepo

We are using turborepo to manage all the applications in the `apps` folder.  
In the root folder you can run `yarn` and it will install all the dependencies of the sub project.  
Then to run all the projects use `yarn dev`

## Dev environment

There is a `docker-compose.dev.yml` which will setup a MariaDB. To run projects use `yarn dev` in the root folder.

## Github actions

In the `.github` folder you will find workflow files for production and staging.
The workflow uses docker compose to setup the right environment.

In these files be sure to change all instances `/repository/project/` with your repository and project name.

### :exclamation: Required changes :exclamation:

Add an action runner where staging and/or prodcution can be deployed on

### :exclamation: Secrets :exclamation:

The following secrets needs to be defined:

-   FLAGSMITH_URL
-   STAGING_DATABASE_PASSWORD
-   STAGING_FLAGSMITH_API_KEY
-   PRODUCTION_DATABASE_PASSWORD
-   PRODUCTION_FLAGSMITH_API_KEY

## Docker-Compose

### :exclamation: Change project name :exclamation:

Everything is prefixed with the project name `project`, you'll need to replace `project` with your project name.

## Package.json

### :exclamation: Change project name :exclamation:

In package.json you beed to change the package name and optional the version

## Nginx.conf

In the root folder you can find nginx.conf. Everything in this is prefixed with the project name `project`, you'll need to replace `project` with your project name.
This basic nginx config can be used to add to the reverse proxy.
