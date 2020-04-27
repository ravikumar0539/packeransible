import skew
from skew.arn import ARN
arn = ARN()
services=arn.service.choices()
services.sort()
print('Enumerating all resources in the following services: ' + ' '.join(services) + '\n')
for service in services:
  arn.service.pattern = service
  for resource in arn:
      with open('listservice', 'a') as file1:
          file1.write(resource)
      with open('detaillist','a') as file2:
          file2.write(resource.data)
  file.close()
