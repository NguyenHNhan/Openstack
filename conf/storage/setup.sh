chmod 640 /etc/cinder/cinder.conf
chgrp cinder /etc/cinder/cinder.conf
systemctl restart cinder-volume
systemctl enable cinder-volume
