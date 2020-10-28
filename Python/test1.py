import pycuda.driver as drv
drv.init()

print ('Se detecta una dispositivo con capacidad CUDA \n{}' .format(drv.Device.count()))
i=0
gpu_device = drv.Device(i)
print ('Dispositivo{}: {}'.format(i,gpu_device.name()))

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
compute_capability = float('%d.%d' % gpu_device.compute_capability())
print ('\t Compute Capability: {}'.format(compute_capability))
#imprimiendo la memoria de la GPU
print ('\t Memory: {} MB'.format(gpu_device.total_memory()))

#vamos a solicitar otros atributos de la GPU y lo guardamos en un diccionario de Pyton
Atributos_GPU = gpu_device.get_attributes().iteritems()

atributos_dispositivo = {}

for k,v in Atributos_GPU:
    atributos_dispositivo[str(k)] = v