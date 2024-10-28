data "aws_efs_file_system" "jenkins" {
  file_system_id = aws_efs_file_system.jenkins.id
}
