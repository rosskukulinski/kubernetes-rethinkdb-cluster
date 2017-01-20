Docker image
============

If you wish to change the probe binary, you can edit the probe.go to
add what you wish. Right now it connects to localhost:28015 and connects
as admin to the db "rethinkdb". It queries the server_status table and
checks for errors. To connect to a different host, set RETHINKDB_URL env
var to host:port.

To build a new probe, run build.sh. build.sh requires
docker. build.sh builds the binary in a docker image.
```bash
# This will produce a probe binary built in a go container
╰─$ ./build.sh 
<snip> 
``
 