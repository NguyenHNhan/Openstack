#PASSDB="123"
SQL_COMMANDS="
DROP DATABASE IF EXISTS keystone;
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO keystone@'localhost' IDENTIFIED BY '$USERDB';
GRANT ALL PRIVILEGES ON keystone.* TO keystone@'%' IDENTIFIED BY '$USERDB';

DROP DATABASE IF EXISTS glance;
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO glance@'localhost' IDENTIFIED BY '$USERDB';
GRANT ALL PRIVILEGES ON glance.* TO glance@'%' IDENTIFIED BY '$USERDB';

DROP DATABASE IF EXISTS nova;
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO nova@'localhost' IDENTIFIED BY '$USERDB';
GRANT ALL PRIVILEGES ON nova.* TO nova@'%' IDENTIFIED BY '$USERDB';
DROP DATABASE IF EXISTS nova_api;
CREATE DATABASE nova_api;
GRANT ALL PRIVILEGES ON nova_api.* TO nova@'localhost' IDENTIFIED BY '$USERDB';
GRANT ALL PRIVILEGES ON nova_api.* TO nova@'%' IDENTIFIED BY '$USERDB';
DROP DATABASE IF EXISTS placement;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_cell0.* TO nova@'localhost' IDENTIFIED BY '$USERDB';
GRANT ALL PRIVILEGES ON nova_cell0.* TO nova@'%' IDENTIFIED BY '$USERDB';
DROP DATABASE IF EXISTS placement;
CREATE DATABASE placement;
GRANT ALL PRIVILEGES ON placement.* TO placement@'localhost' IDENTIFIED BY '$USERDB';
GRANT ALL PRIVILEGES ON placement.* TO placement@'%' IDENTIFIED BY '$USERDB';

DROP DATABASE IF EXISTS neutron_ml2;
CREATE DATABASE neutron_ml2;
GRANT ALL PRIVILEGES ON neutron_ml2.* TO neutron@'localhost' IDENTIFIED BY '$USERDB';
GRANT ALL PRIVILEGES ON neutron_ml2.* TO neutron@'%' IDENTIFIED BY '$USERDB';

DROP DATABASE IF EXISTS cinder;
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO cinder@'localhost' IDENTIFIED BY '$PASSDB';
GRANT ALL PRIVILEGES ON cinder.* TO cinder@'%' IDENTIFIED BY '$PASSDB';
FLUSH PRIVILEGES;
"

mysql <<< "$SQL_COMMANDS"

