plugin "terraform" {
  enabled = true
  preset  = "all"
}

rule "terraform_standard_module_structure" {
  enabled = false
}

plugin "aws" {
  enabled = true
  version = "0.49.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
