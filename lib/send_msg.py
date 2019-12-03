import argparse
import json
# Python 2 and 3: alternative 4
try:
    from urllib.parse import urlparse, urlencode
    from urllib.request import urlopen, Request
    from urllib.error import HTTPError
except ImportError:
    from urlparse import urlparse
    from urllib import urlencode
    from urllib2 import urlopen, Request, HTTPError

ap = argparse.ArgumentParser()
ap.add_argument('--chat_url', required=True)
ap.add_argument('--web_hook_url', required=True)
ap.add_argument('--thread_key', required=True)
ap.add_argument('--message', required=True)
args = ap.parse_args()

payload = {
    'webhook': args.web_hook_url,
    'threadkey': args.thread_key,
    'message': args.message
}

r = Request(
    url=args.chat_url,
    data=json.dumps(payload).encode(),
    headers={
        'Content-Type': 'application/json',
        'charset': 'utf-8',
    }
)

resp = urlopen(r)

if resp.getcode() != 200:
    print("failed to send notification")
    print("endpoint status code = {}".format(resp.getcode()))
    print("endpoint response body:")
    print(resp.read())
else:
    print("notification send successfully")

