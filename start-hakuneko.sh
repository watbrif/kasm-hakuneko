#!/bin/bash
# Start kasmVNC in the background
/usr/bin/supervisord &

# Wait for VNC server to start
sleep 5

# Start HakuNeko
cd /opt/hakuneko
npm start
