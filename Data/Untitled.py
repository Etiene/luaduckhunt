import json
from pprint import pprint

with open('ibm.json') as data_file:    
	data = json.load(data_file)

i = 0

#for elem in data['data'][0]['securityData']['fieldData']:
	#print elem['date'] + "," + str(elem['OPEN'])
	#print str(i) + "," + str(elem['PX_LAST'])

for elem in data['data'][1]['securityData']['fieldData']:
	print str(i) + "," + str(elem['PX_LAST'])
	i += 1
