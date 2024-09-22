# Web Tier Security Group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow TLS inbound traffic and all outbound traffic for the web tier"
  vpc_id      = aws_vpc.dev_vpc.id

  tags = {
    Name = "web_sg"
  }
}

# Inbound Rules for Web Tier
resource "aws_security_group_rule" "web_sg_allow_tls_ipv4" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web_sg_allow_tls_ipv6" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web_sg_allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.web_sg.id
}

# App Tier Security Group
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow traffic between app and web tiers, and all outbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  tags = {
    Name = "app_sg"
  }
}

# Inbound Rules for App Tier
resource "aws_security_group_rule" "app_sg_allow_tls_from_web_tier" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "app_sg_allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.app_sg.id
}

# Database Tier Security Group
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow traffic only from the app tier"
  vpc_id      = aws_vpc.dev_vpc.id

  tags = {
    Name = "db_sg"
  }
}

# Inbound Rules for DB Tier
resource "aws_security_group_rule" "db_sg_allow_from_app_tier" {
  type                     = "ingress"
  from_port                = 3306  # Example for MySQL. Use the appropriate port for your database.
  to_port                  = 3306  # Example for MySQL. Use the appropriate port for your database.
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id        = aws_security_group.db_sg.id
}

# Outbound Rules for DB Tier
resource "aws_security_group_rule" "db_sg_allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.db_sg.id
}
