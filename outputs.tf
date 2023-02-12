output "Jenkins-Server-URL" {
  value = "http://${aws_instance.jenkins-server.public_ip}:8080"
}

output "SSH" {
  value = "ssh -i nvirginia.pem ec2-user@${aws_instance.jenkins-server.public_ip}"
}

output "Jenkins_Password" {
  value = "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}