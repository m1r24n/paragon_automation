cat > meta-data << EOF
instance-id: local-001
EOF
cat > user-data << EOF
#cloud-config
password: pass01
chpasswd: { expire: False }
ssh_pwauth: True
EOF
