// Generate a private key locally
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

// Output the public key in OpenSSH format
output "public_key" {
  value = tls_private_key.key.public_key_openssh
}
