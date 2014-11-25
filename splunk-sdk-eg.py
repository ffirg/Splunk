#!/bin/env python

#
# Example Splunk Python SDK script using the RESTful API
#

import splunklib.client as client
import splunklib.results as results

HOST = "localhost"
PORT = 8089
#USERNAME = "user_goes_here"
#PASSWORD = "password_goes_here"

service = client.connect(
        host=HOST,
        port=PORT,
        username=USERNAME,
        password=PASSWORD
        )

kwargs = {
        "earliest_time": "-7d",
        "latest_time": "now",
        "search_mode": "normal",
        "exec_mode": "blocking"
        }

#searchquery = "search index=ssa sourcetype=\"vcenter\" | tail 2"

job = service.jobs.create(searchquery, **kwargs)
print "Job completed...printing results!\n"

search_results = job.results()
# just use this to check results. Remove from real code:
print search_results

#reader = results.ResultsReader(search_results)
#for result in reader:
 #print "Result: %s => %s" % (result['clientip'],result['count']
# print result
