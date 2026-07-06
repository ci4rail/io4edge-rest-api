
<h1 id="sio06-prometheus-metrics-api">SIO06 Prometheus Metrics API v1.0.0</h1>

This is the API documentation to get prometheus metrics from SIO06 devices using HTTP.

The API is available at http://my-io4edge-device:9100/metrics.

Base URLs:

* Example SIO06: <a href="http://my-io4edge-device:9100/metrics">http://my-io4edge-device:9100/metrics</a>

<h2 id="sio06-prometheus-metrics-api-default">Default</h2>

## get__metrics

`GET /metrics`

*Get prometheus metrics*

Get prometheus metrics from the device.

The metrics are served in the prometheus text format.

List of metrics is shown in the example response (Firmware sio06_01_02_default version 2.3.0)

<h3 id="get__metrics-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|
|500|[Internal Server Error](https://tools.ietf.org/html/rfc7231#section-6.6.1)|Internal Server Error|None|

> Example responses

> 200 Response

```
"# HELP reset_count Number of resets occurred\n# TYPE reset_count counter\nreset_count{reason=\"unknown\"} 0\nreset_count{reason=\"poweron\"} 5\nreset_count{reason=\"external\"} 0\nreset_count{reason=\"software\"} 3\nreset_count{reason=\"panic\"} 0\nreset_count{reason=\"interruptwd\"} 0\nreset_count{reason=\"taskwd\"} 0\nreset_count{reason=\"wd\"} 0\nreset_count{reason=\"deepsleep\"} 0\nreset_count{reason=\"brownout\"} 0\nreset_count{reason=\"sdio\"} 0\nreset_count{reason=\"usb\"} 119\nreset_count{reason=\"jtag\"} 0\nreset_count{reason=\"efuse\"} 0\nreset_count{reason=\"powerglitch\"} 0\nreset_count{reason=\"cpulockup\"} 0\n# HELP free_heap_bytes Free heap (bytes)\n# TYPE free_heap_bytes gauge\nfree_heap_bytes{} 246368\n# HELP up_seconds uptime (seconds)\n# TYPE up_seconds counter\nup_seconds{} 432.457876\n# HELP number_packets_received Number of trdp packets received at the sink\n# TYPE number_packets_received counter\nnumber_packets_received{type=\"good\"} 141\nnumber_packets_received{type=\"lost\"} 23\nnumber_packets_received{type=\"seq_resync\"} 4\nnumber_packets_received{type=\"bad_crc\"} 0\nnumber_packets_received{type=\"bad_comid\"} 0\nnumber_packets_received{type=\"bad_version\"} 0\nnumber_packets_received{type=\"bad_type\"} 0\nnumber_packets_received{type=\"short\"} 0\nnumber_packets_received{type=\"bad_len\"} 0\nnumber_packets_received{type=\"seq_old\"} 0\n# HELP number_packets_published Number of published trdp packets from the source\n# TYPE number_packets_published counter\nnumber_packets_published{type=\"good\"} 2137\nnumber_packets_published{type=\"failed\"} 11\n# HELP ana Analog input values(-1 to 1)\n# TYPE ana gauge\nana{channel=\"ch1\"} -0.004237\nana{channel=\"ch2\"} -0.004250\n# HELP bin Digital input values (Bitmask)\n# TYPE bin gauge\nbin{} 0\n# HELP relay Desired relay states (Bitmask)\n# TYPE relay gauge\nrelay{} 0\n# HELP adc_errors ADC errors\n# TYPE adc_errors counter\nadc_errors{type=\"spi\"} 0\nadc_errors{type=\"tout\"} 0\n# HELP wd_state Watchdog state (1=DEACTIVATED, 2=STOPPED, 3=RUNNING, 4=EXEC_ACTION, 5=ACTION_DONE)\n# TYPE wd_state gauge\nwd_state{} 1\n# HELP wd_time_since_last_trigger_us Time since last watchdog trigger (us) (0 when wd not running)\n# TYPE wd_time_since_last_trigger_us gauge\nwd_time_since_last_trigger_us{} 0"
```

<aside class="success">
This operation does not require authentication
</aside>

