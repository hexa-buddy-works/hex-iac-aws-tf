resource "aws_organizations_policy" "scp" {
  name        = var.scp_name
  description = var.scp_description
  type        = "SERVICE_CONTROL_POLICY"
  content     = var.scp_policy
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "scp_attach" {
  policy_id = aws_organizations_policy.scp.id
  target_id = var.target_ou_id
}