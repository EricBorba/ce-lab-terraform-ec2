#!/bin/bash
set -e

yum update -y
yum install -y httpd

systemctl enable httpd
systemctl start httpd

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

AZ=$(curl -s \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/style.css <<CSS
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: linear-gradient(135deg, #1e3c72, #2a5298);
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    color: white;
}

.container {
    background: rgba(255,255,255,0.15);
    padding: 40px;
    border-radius: 20px;
    text-align: center;
    width: 80%;
    max-width: 600px;
}

.info {
    background: rgba(255,255,255,0.12);
    padding: 20px;
    border-radius: 12px;
    margin-top: 20px;
}
CSS

cat > /var/www/html/index.html <<HTML
<html>
<head>
    <title>Terraform Web Server</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>🚀 Hello from Terraform Managed EC2!</h1>
        <div class="info">
            <p>Instance ID: $INSTANCE_ID</p>
            <p>Availability Zone: $AZ</p>
        </div>
    </div>
</body>
</html>
HTML