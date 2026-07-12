#!/bin/bash

apt-get update -y
apt-get install -y apache2

systemctl enable apache2
systemctl start apache2

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Terraform Project - Server 1</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
    background:linear-gradient(135deg,#0F2027,#203A43,#2C5364);
    overflow:hidden;
}

.container{
    width:700px;
    padding:45px;
    border-radius:20px;
    background:rgba(255,255,255,0.12);
    backdrop-filter:blur(12px);
    box-shadow:0 10px 40px rgba(0,0,0,0.4);
    text-align:center;
    color:white;
}

h1{
    font-size:42px;
    margin-bottom:15px;
    animation:glow 2s infinite alternate;
}

@keyframes glow{
    from{
        text-shadow:0 0 10px #00e5ff;
    }
    to{
        text-shadow:0 0 30px #00ff95;
    }
}

.subtitle{
    font-size:20px;
    margin-bottom:30px;
    color:#d6f5ff;
}

.info-box{
    margin-top:20px;
    padding:20px;
    background:rgba(255,255,255,0.15);
    border-radius:15px;
}

.info-box h2{
    margin-bottom:15px;
}

.instance{
    color:#FFD54F;
    font-size:24px;
    font-weight:bold;
}

.badge{
    display:inline-block;
    margin-top:25px;
    padding:10px 25px;
    background:#4CAF50;
    border-radius:30px;
    font-size:18px;
    font-weight:bold;
}

.footer{
    margin-top:35px;
    color:#dddddd;
    font-size:14px;
}

.circle1{
    position:absolute;
    width:250px;
    height:250px;
    background:#00BCD4;
    border-radius:50%;
    top:-80px;
    left:-80px;
    opacity:.2;
}

.circle2{
    position:absolute;
    width:300px;
    height:300px;
    background:#8E24AA;
    border-radius:50%;
    bottom:-100px;
    right:-100px;
    opacity:.2;
}
</style>

</head>

<body>

<div class="circle1"></div>
<div class="circle2"></div>

<div class="container">

    <h1>🚀 Terraform Project</h1>

    <div class="subtitle">
        Welcome to <strong>Server 1</strong>
    </div>

    <div class="info-box">

        <h2>Load Balancer Demo</h2>

        

        <div class="badge">
            ✅ Page 1
        </div>

    </div>

    <div class="footer">
        Hosted on AWS EC2 • Provisioned with Terraform • Behind an Application Load Balancer
    </div>

</div>

</body>
</html>
EOF