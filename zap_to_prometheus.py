from flask import Flask, Response
from prometheus_client import CollectorRegistry, Gauge, generate_latest
from bs4 import BeautifulSoup

app = Flask(__name__)

# Define the path to the ZAP report
ZAP_REPORT_PATH = "zap-report.html"

def parse_zap_report():
    """Parses ZAP HTML report and extracts vulnerability counts."""
    registry = CollectorRegistry()

    # Prometheus metrics
    zap_high_alerts = Gauge('zap_high_alerts', 'Number of High Severity Alerts in ZAP Report', registry=registry)
    zap_medium_alerts = Gauge('zap_medium_alerts', 'Number of Medium Severity Alerts in ZAP Report', registry=registry)
    zap_low_alerts = Gauge('zap_low_alerts', 'Number of Low Severity Alerts in ZAP Report', registry=registry)

    # Read and parse the HTML file
    try:
        with open(ZAP_REPORT_PATH, "r", encoding="utf-8") as file:
            soup = BeautifulSoup(file, "html.parser")

        # Extract alerts
        high_count = len(soup.find_all(text="High"))
        medium_count = len(soup.find_all(text="Medium"))
        low_count = len(soup.find_all(text="Low"))

        # Set Prometheus metrics
        zap_high_alerts.set(high_count)
        zap_medium_alerts.set(medium_count)
        zap_low_alerts.set(low_count)

    except Exception as e:
        print(f"Error reading ZAP report: {e}")

    return registry

@app.route('/metrics')
def metrics():
    """Expose Prometheus metrics"""
    registry = parse_zap_report()
    return Response(generate_latest(registry), mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
