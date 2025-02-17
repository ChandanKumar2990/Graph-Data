resource "aws_security_group" "eclipse_neptune_security_group" {
  name        = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-neptune-sg"
  description = "Allow traffic for Neptune Database"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 8182
    to_port   = 8182
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks["default_subnet_cidrs"]
  }

  egress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks["default_subnet_cidrs"]
  }

  ingress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks["selected_subnet_cidrs"]
  }

  egress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks["selected_subnet_cidrs"]
  }

  tags = merge(tomap({ "access-env" = var.env }).var.tags)
}
