output "public_ip" {
  # value = aws_instance.masq_node.public_ip
  # value = aws_instance.masq_node[count.index]
  # Need to Fix this with instance_count / count
  value = 1
}
 