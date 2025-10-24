load_balancers:
  hosts:
    frontend_alb:
      dns_name: ${frontend_alb_dns}
    backend_alb:
      dns_name: ${backend_alb_dns}

frontend_servers:
  hosts:
    frontend_1:
      ansible_host: ${frontend_ip_1}
    frontend_2:
      ansible_host: ${frontend_ip_2}

backend_servers:
  hosts:
    backend_1:
      ansible_host: ${backend_ip_1}
      private_host: ${backend_private_ip_1}
    backend_2:
      ansible_host: ${backend_ip_2}
      private_host: ${backend_private_ip_2}
  
db_server:
  hosts:
    db:
      ansible_host: ${db_ip}
      private_host: ${db_private_ip}

all_servers:
  children:
    frontend_servers:
    backend_servers:
    db_server:
