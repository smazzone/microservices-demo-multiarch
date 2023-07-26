#!/bin/bash
sed -e "s~FRONTEND_LB~${FRONTEND_LB}~" ./dash/microservices/nginx.conf > /etc/nginx/nginx.conf