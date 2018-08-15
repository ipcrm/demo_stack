data "template_file" "init-int-win" {
  template = "${file("userdata/init-win.tpl")}"
  vars {
    master_ip  = "${aws_eip.master-ip.private_ip}"
    target_env = "integration"
  }
}

data "template_file" "init-qa-win" {
  template = "${file("userdata/init-win.tpl")}"
  vars {
    master_ip  = "${aws_eip.master-ip.private_ip}"
    target_env = "qa"
  }
}

data "template_file" "init-prod-win" {
  template = "${file("userdata/init-win.tpl")}"
  vars {
    master_ip  = "${aws_eip.master-ip.private_ip}"
    target_env = "prod"
  }
}

data "template_file" "init-sbx-win" {
  template = "${file("userdata/init-win.tpl")}"
  vars {
    master_ip  = "${aws_eip.master-ip.private_ip}"
    target_env = "sbx"
  }
}

resource "aws_instance" "demo-win-int" {
  count                  = "${var.machine_counts["int_win"]}"
  ami                    = "${var.amis["windows"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["windows"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-int-win.rendered}"
  get_password_data      = true

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-win-${count.index}"
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

output "win-int-ip" {
  value = ["${aws_instance.demo-win-int.*.public_ip}"]
}

resource "aws_instance" "demo-win-qa" {
  count                  = "${var.machine_counts["qa_win"]}"
  ami                    = "${var.amis["windows"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["windows"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-qa-win.rendered}"
  get_password_data      = true

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-win-${count.index}"
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

output "win-ip-qa" {
  value = ["${aws_instance.demo-win-qa.*.public_ip}"]
}


resource "aws_instance" "demo-win-prod" {
  count                  = "${var.machine_counts["prod_win"]}"
  ami                    = "${var.amis["windows"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["windows"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-prod-win.rendered}"
  get_password_data      = true

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-win-${count.index}"
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

output "win-ip-prod" {
  value = ["${aws_instance.demo-win-prod.*.public_ip}"]
}

resource "aws_instance" "demo-win-sbx" {
  count                  = "${var.machine_counts["sbx_win"]}"
  ami                    = "${var.amis["windows"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["windows"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-sbx-win.rendered}"
  get_password_data      = true

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-win-${count.index}"
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

output "win-sbx-ip" {
  value = ["${aws_instance.demo-win-sbx.*.public_ip}"]
}
