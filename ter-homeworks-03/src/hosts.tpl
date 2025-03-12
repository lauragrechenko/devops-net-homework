[webservers]
%{~ for server in web_servers ~}

${server.name} ansible_host=${server.network_interface[0].nat_ip_address != "" ? server.network_interface[0].nat_ip_address : server.network_interface[0].ip_address} fqdn=${server.fqdn}
%{~ endfor ~}


[databases]
%{~ for server in db_servers ~}

${server.name} ansible_host=${server.network_interface[0].nat_ip_address != "" ? server.network_interface[0].nat_ip_address : server.network_interface[0].ip_address} fqdn=${server.fqdn}
%{~ endfor ~}


[storage]
%{~ for server in storage_servers ~}

${server.name} ansible_host=${server.network_interface[0].nat_ip_address != "" ? server.network_interface[0].nat_ip_address : server.network_interface[0].ip_address} fqdn=${server.fqdn}
%{~ endfor ~}