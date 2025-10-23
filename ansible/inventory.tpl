frontend_server:
  hosts:
    frontend:
      ansible_host: ${frontend_ip}

backend_server:
  hosts:
    backend:
      ansible_host: ${backend_ip}
      private_host: ${backend_private_ip}
  
db_server:
  hosts:
    db:
      ansible_host: ${db_ip}
      private_host: ${db_private_ip}

all_servers:
  children:
    frontend_server:
    backend_server:
    db_server:
