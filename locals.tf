
locals {
  repository_url = "https://github.com/TOnodera/nextjs-aplify-deploy"
}

locals {
  amplify_app_environment_variables = {
    next_public_api_url = "https://api.t-dera.com"
    custom_image        = "public.ecr.aws/docker/library/node:20.11.0"
  }
}

locals {
  domain_name = "t-dera.com"
}
