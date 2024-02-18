output "vpc_id" {
  value = aws_vpc.new-vpc.id
}

output "subent_ids" {
  value = aws_subnet.subnets[*].id
}