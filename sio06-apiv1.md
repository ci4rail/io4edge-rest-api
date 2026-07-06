
<h1 id="sio06-management-api">SIO06 Management API v1.1.0</h1>

This is the API documentation to manage SIO06 devices via HTTPS.
This API does not serve metrics. For performance reasons, metrics are served at http://my-io4edge-device:9100/metrics.

The API is secured with basic auth with a single user name and password.
- user: "io4edge", default password: "core_io4edge" (unless a factory default password has been set)

The password can be changed with the PUT /users/io4edge/basic_auth endpoint.

The API is available at https://my-io4edge-device/api/v1

Performance note: Due to hardware limitations, the initial TLS handshake can take up to 2 seconds.
Clients should reuse the TLS session where possible to avoid this delay.

Base URLs:

* Example SIO06: <a href="https://192.168.23.72/api/v1">https://192.168.23.72/api/v1</a>

