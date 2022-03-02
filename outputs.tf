output "public_ip" {
  # value = aws_instance.masq_node.public_ip
  # value = aws_instance.masq_node[count.index]
  value = 1
}
 