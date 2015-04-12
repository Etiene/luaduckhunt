import json
from pprint import pprint

with open('ibm.json') as data_file:    
	data = json.load(data_file)

i = 0
buffer = []
min = 1000000.0
max = 0.0

width = 256.0*3.0
intervall = int(width/40)
lol = 1.0/19

with open('data.lua', 'w') as out:
	out.write("local data = {")
	for elem in data['data'][0]['securityData']['fieldData']:
		buffer.append([i, elem['OPEN']])
		if elem['OPEN'] < min:
			min = elem['OPEN']
		if elem['OPEN'] > max:
			max = elem['OPEN']
		i += 1

	intervall = max - min

	for elem in buffer:
		elem[1] = (elem[1]-min)/intervall
		#out.write(str(elem[1]) + ",")
	#buffer.append(buffer[40])
	
	ii= 0
	#for elem in buffer:
		#print elem[1]
	

	for i in range(0,40):
		a = buffer[i][1]
		b = buffer[i+1][1]
		for i2 in range(19):
			o = i2/19.0
			u = 1.0-o
			out.write(str(b*o+u*a) + ",\n")
	
	"""
	for i in range(1,256*3):
		val = buffer[i-1][1] +   (buffer[i][1]-buffer[i-1][1]) *40/(256*3)
		
		o1 = int(i/intervall)
		print o1
		p = int(i%intervall)
		x = float(p)/intervall
		y = 1.0-x
		val = x * buffer[o1][1] + y * buffer[o1+1][1]
		out.write(str(val) + ",\n")
	"""
	out.write("} return data")
		

	
	
"""
for elem in data['data'][1]['securityData']['fieldData']:
	print str(i) + "," + str(elem['PX_LAST'])
	i += 1
"""