#!/bin/bash

OUTPUT_DIR=${1:-reports}

mkdir -p $OUTPUT_DIR

cat <<EOF > $OUTPUT_DIR/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Performance Dashboard</title>
  <style>
    body { font-family: Arial; text-align: center; }
    .card { border: 1px solid #ddd; padding: 20px; margin: 20px; display: inline-block; }
    .pass { color: green; }
    .fail { color: red; }
  </style>
</head>

<body>

<h1>🚀 Performance Dashboard</h1>

<div class="card">
  <h2>Throughput</h2>
  <p id="throughput">-</p>
</div>

<div class="card">
  <h2>P90</h2>
  <p id="p90">-</p>
</div>

<div class="card">
  <h2>Status</h2>
  <p id="status">-</p>
</div>

<h2>📊 Reports</h2>
<ul>
  <li><a href="load-test/index.html">Load Test</a></li>
</ul>

<script>
fetch('summary.json')
  .then(res => res.json())
  .then(data => {
    document.getElementById('throughput').innerText = data.throughput + " req/s";
    document.getElementById('p90').innerText = data.p90 + " ms";

    const statusEl = document.getElementById('status');
    statusEl.innerText = data.status;

    if (data.status === "PASS") {
      statusEl.className = "pass";
    } else {
      statusEl.className = "fail";
    }
  });
</script>

</body>
</html>
EOF