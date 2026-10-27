<h3 align="center">Secure CI/CD Pipeline for Cloud Deployments via Terraform</h3>

<p align="center">
  <img src="https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform">
  <img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logoColor=white" alt="AWS">
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" alt="GitHub Actions">
  <img src="https://img.shields.io/badge/Checkov-F04E23?style=for-the-badge&logo=paloaltonetworks&logoColor=white" alt="Checkov">
  <img src="https://img.shields.io/badge/TFLint-5C4EE5?style=for-the-badge" alt="TFLint">

</p>

## Overview

This project is a secure CI/CD pipeline for AWS infrastructure, built with Terraform and GitHub Actions.

Resources created by hand in the console (ClickOps) are hard to review and audit. A public S3 bucket or an unencrypted volume can go live without anyone noticing, and over time environments drift apart because nobody knows exactly what changed or when.

Moving from ClickOps to an automated, versioned and repeatable setup means every change goes through code first. In this project, Checkov and TFLint scan the Terraform before anything is applied, and the pipeline stops for revision when they find a problem. The fix is still done by the engineer, but the misconfiguration never reaches the AWS account.

GitHub Actions authenticates to AWS through OIDC, so no long-lived access keys are stored in the repository. Plan and apply run as separate jobs, apply requires manual approval



## Considerations

The purpose of this project is to demonstrate in a simplified way that migrate from ClickOps to a CI/CD Pipeline deployment strategy adds compliance and security to cloud environments. A real-world production repository would be composed of multi-environments, double-approval per environment, and a larger amount of steps, jobs and actions.


