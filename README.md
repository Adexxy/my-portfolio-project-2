# Simple Node.js Commerce App

This repository contains a simple Node.js commerce application built using React for the frontend and Node.js for the backend. The application is set up with continuous integration (CI) and continuous deployment (CD) using various tools.

## Continuous Integration (CI)

### Tools Used
- GitHub: Version control and collaborative development platform.
- Node.js: JavaScript runtime for server-side development.
- React: JavaScript library for building user interfaces.
- Jenkins: An open-source automation server for CI.
- Nexus: Repository manager used for managing binary artifacts.
- Docker: Platform for containerization of applications.
- Docker Hub: Cloud-based registry for sharing Docker images.

### CI Workflow

1. **Code Changes**: Developers make code changes and push them to the GitHub repository.

2. **GitHub Actions**: GitHub Actions are triggered on each push to the repository, running automated CI workflows.

3. **Build and Test**: Jenkins, running within a Docker container, builds the Node.js backend and React frontend, runs tests, and checks for code quality.

4. **Artifact Storage**: Built artifacts and dependencies are stored in Nexus for versioned and controlled management.
   
5. **Build and Push Docker Image**: The Docker image of the application is built and pushed to Docker Hub for containerized deployment.

## Continuous Deployment (CD)

### Tools Used
- GitHub: Version control and collaborative development platform.
- Kubernetes: An open-source container orchestration system.
- ArgoCD: A declarative, GitOps continuous delivery tool for Kubernetes.
- Docker: Platform for containerization of applications.
- Docker Hub: Cloud-based registry for sharing Docker images.

### CD Workflow

1. **Release Tagging**: When a specific version is ready for release, a release tag is created in the GitHub repository.

2. **GitHub Actions**: GitHub Actions are triggered by the release tag, initiating the CD workflow.

3. **Build Docker Images**: The application is packaged into Docker images and pushed to Docker Hub.

4. **Kubernetes Deployment**: ArgoCD detects the updated images and automatically deploys the new version to the Kubernetes cluster.

This setup ensures that the application is continuously integrated, tested, and deployed whenever changes are made to the codebase, providing a streamlined development and deployment process for the commerce application.
