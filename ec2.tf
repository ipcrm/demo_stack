locals {
  common_tags = "${map(
    "created_by"       , "matthew.cadorette",
    "department"       , "edu",
    "email"            , "mattc@puppet.com",
    "project"          , "demo_stack",
    "lifetime"         , "4w",
  )}"
}

resource "aws_instance" "puppet_master_instance" {
  ami                    = "${var.amis["master"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  count                  = "1"
  instance_type          = "${var.instance_type["master"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${file("userdata/master.sh")}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-PuppetMaster${count.index}"
   )
  )}"


  lifecycle {
    ignore_changes = ["tags", "source_dest_check", "ami", "user_data", "vpc_security_group_ids"]
  }
}

resource "aws_eip" "master-ip" {
  instance = "${aws_instance.puppet_master_instance.id}"
  vpc      = true
}

data "template_file" "init-cd4pe" {
  template = "${file("userdata/init-cd4pe.tpl")}"
  vars {
    master_ip = "${aws_eip.master-ip.private_ip}"
  }
}

resource "aws_instance" "cd4pe" {
  ami                    = "${var.amis["linux"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  count                  = "1"
  instance_type          = "${var.instance_type["cd4pe"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-cd4pe.rendered}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.key_name}-cd4pe-${count.index}"
   )
  )}"

  lifecycle {
    ignore_changes = ["tags", "source_dest_check", "ami", "user_data", "vpc_security_group_ids"]
  }
}

resource "aws_eip" "cd4pe-ip" {
  instance = "${aws_instance.cd4pe.id}"
  vpc      = true
}

data "template_file" "init-lnx" {
  template = "${file("userdata/init-lnx.tpl")}"
  vars {
    master_ip = "${aws_eip.master-ip.private_ip}"
  }
}

data "template_file" "init-win" {
  template = "${file("userdata/init-win.tpl")}"
  vars {
    master_ip = "${aws_eip.master-ip.private_ip}"
  }
}

resource "aws_instance" "demo-lnx" {
  count                  = "${var.linux_count}"
  ami                    = "${var.amis["linux"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["linux"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-lnx.rendered}"

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

output "lnx-ip" {
  value = ["${aws_instance.demo-lnx.*.public_ip}"]
}

resource "aws_instance" "demo-win" {
  count                  = "${var.windows_count}"
  ami                    = "${var.amis["windows"]}"
  availability_zone      = "${element(split(",", local.pegged_azs), count.index)}"
  instance_type          = "${var.instance_type["windows"]}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(aws_subnet.demo_stack.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.demo_stack-securitygroup.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.init-win.rendered}"
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

output "win-ip" {
  value = ["${aws_instance.demo-win.*.public_ip}"]
}
