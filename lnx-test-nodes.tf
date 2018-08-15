data "template_file" "init-lnx-int" {
  template = "${file("userdata/init-lnx.tpl")}"
  vars {
    master_ip  = "${aws_eip.master-ip.private_ip}"
    target_env = "int"
  }
}

data "template_file" "init-lnx-qa" {
  template = "${file("userdata/init-lnx.tpl")}"
  vars {
    master_ip  = "${aws_eip.master-ip.private_ip}"
    target_env = "qa"
  }
}

data "template_file" "init-lnx-prod" {
  template = "${file("userdata/init-lnx.tpl")}"
  vars {
    master_ip  = "${aws_eip.master-ip.private_ip}"
    target_env = "prod"
  }
}

data "template_file" "init-lnx-sbx" {
  template = "${file("userdata/init-lnx.tpl")}"
  vars {
    master_ip  = "${aws_eip.master-ip.private_ip}"
    target_env = "sbx"
  }
}

resource "aws_instance" "demo-lnx-int" {
  count                  = "${var.machine_counts["int_lnx"]}"
  ami                    = "${var.amis["linux"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["linux"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-lnx-int.rendered}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-lnx-${count.index}"
   )
  )}"

  lifecycle {
    ignore_changes = ["tags", "source_dest_check", "ami", "user_data", "vpc_security_group_ids"]
  }

  provisioner "remote-exec" {
    when   = "destroy"
    inline = [
      "sudo /opt/puppetlabs/puppet/bin/puppet node purge ${self.public_dns}"
    ]
    connection {
      user        = "centos"
      host        = "${aws_instance.puppet_master_instance.public_ip}"
      private_key = "${file("pem/id_rsa")}"
    }
  }
}

output "lnx-int-ip" {
  value = ["${aws_instance.demo-lnx-int.*.public_ip}"]
}

resource "aws_instance" "demo-lnx-qa" {
  count                  = "${var.machine_counts["qa_lnx"]}"
  ami                    = "${var.amis["linux"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["linux"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-lnx-qa.rendered}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-lnx-${count.index}"
   )
  )}"

  lifecycle {
    ignore_changes = ["tags", "source_dest_check", "ami", "user_data", "vpc_security_group_ids"]
  }

  provisioner "remote-exec" {
    when   = "destroy"
    inline = [
      "sudo /opt/puppetlabs/puppet/bin/puppet node purge ${self.public_dns}"
    ]
    connection {
      user        = "centos"
      host        = "${aws_instance.puppet_master_instance.public_ip}"
      private_key = "${file("pem/id_rsa")}"
    }
  }
}

output "lnx-qa-ip" {
  value = ["${aws_instance.demo-lnx-qa.*.public_ip}"]
}

resource "aws_instance" "demo-lnx-prod" {
  count                  = "${var.machine_counts["prod_lnx"]}"
  ami                    = "${var.amis["linux"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["linux"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-lnx-prod.rendered}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-lnx-${count.index}"
   )
  )}"

  lifecycle {
    ignore_changes = ["tags", "source_dest_check", "ami", "user_data", "vpc_security_group_ids"]
  }

  provisioner "remote-exec" {
    when   = "destroy"
    inline = [
      "sudo /opt/puppetlabs/puppet/bin/puppet node purge ${self.public_dns}"
    ]
    connection {
      user        = "centos"
      host        = "${aws_instance.puppet_master_instance.public_ip}"
      private_key = "${file("pem/id_rsa")}"
    }
  }
}

output "lnx-prod-ip" {
  value = ["${aws_instance.demo-lnx-prod.*.public_ip}"]
}

resource "aws_instance" "demo-lnx-sbx" {
  count                  = "${var.machine_counts["sbx_lnx"]}"
  ami                    = "${var.amis["linux"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["linux"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-lnx-sbx.rendered}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-lnx-${count.index}"
   )
  )}"

  lifecycle {
    ignore_changes = ["tags", "source_dest_check", "ami", "user_data", "vpc_security_group_ids"]
  }

  provisioner "remote-exec" {
    when   = "destroy"
    inline = [
      "sudo /opt/puppetlabs/puppet/bin/puppet node purge ${self.public_dns}"
    ]
    connection {
      user        = "centos"
      host        = "${aws_instance.puppet_master_instance.public_ip}"
      private_key = "${file("pem/id_rsa")}"
    }
  }
}

output "lnx-sbx-ip" {
  value = ["${aws_instance.demo-lnx-sbx.*.public_ip}"]
}
