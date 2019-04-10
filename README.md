# Ptxdist
Fork of pengutronix ptxdist buildsystem.

Please refer to the orignal _README_.

# Installation
To install PTXdist, just run
```
./configure --prefix=<installpath>
```

to configure the packet, then
```
make
```
to build everything and
```
sudo make install
```
to install it. When you start using PTXdist, make sure your $PATH
environment variable points to <installpath>/bin, because that's where
the ptxdist frontend program is being installed to.


