output "Demo Stack Information" {
  value = <<PUPPETMASTER
    Data
    Master EIP        = "${join(",", aws_eip.master-ip.*.public_ip)}"
    Master Public DNS = "${join(",", aws_instance.puppet_master_instance.*.public_dns)}"
    cd4pe  EIP        = "${join(",", aws_eip.cd4pe-ip.*.public_ip)}"
    cd4pe  Public DNS = "${join(",", aws_instance.cd4pe.*.public_dns)}"
  PUPPETMASTER
}
