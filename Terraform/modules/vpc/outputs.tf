output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.votingApp_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet" {
  value = aws_subnet.private_subnet.id
}

output "votingApp_igw" {
  value = aws_internet_gateway.votingApp_igw.id
}

output "nat_eip" {
  value = aws_eip.nat_eip.id
}

output "votingApp_nat_gw" {
  value = aws_nat_gateway.votingApp_nat_gw.id
}


