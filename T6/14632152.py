from argparse import ArgumentParser


class Proceso:

    procesos = {}

    def __init__(self, nombre, vir_size, page_size):
        self.nombre = nombre
        self.vir_size = vir_size
        self.page_size = page_size
        self._paginas_usadas = set()
        self.tabla_paginas = [[None, 0] for i in range(vir_size // page_size)]
        self.page_faults = 0
        self.pagina_actual = None
        self.__class__.procesos[nombre] = self

    @property
    def paginas_usadas(self):
        return len(self._paginas_usadas)

    def mapear(self, pagina, marco):
        self.tabla_paginas[pagina][0] = marco
        self.tabla_paginas[pagina][1] = 0

    def mover_a_disco(self, pagina):
        self.tabla_paginas[pagina][1] = 1

    def __repr__(self):
        return 'Proceso(%d páginas usadas, %d page faults)' % (
            self.paginas_usadas, self.page_faults)

    def __str__(self):
        return '%d páginas usadas | %d page faults' % (
            self.paginas_usadas, self.page_faults)


class MemFis:

    def __init__(self, mem_size, page_size):
        self.mem_size = mem_size
        self.page_size = page_size
        self.marcos = [[i, None, None, 0] for i in range(mem_size // page_size)]

    def __repr__(self):
        return 'Memoria(%d bytes, %d marcos)' % (
            self.mem_size, self.mem_size // self.page_size)

    def esta_mapeado(self, proceso, pagina):
        for marco in self.marcos:
            if marco[1] == proceso and marco[2] == pagina:
                return True
        return False

    def marco_vacio(self):
        vacios = [i for i in self.marcos if i[1] is None]
        return vacios[0] if vacios else None

    def mapear(self, proceso, pagina, timestamp):
        marco = self.marco_vacio()
        if marco is None:
            marco = self.fifo()
            proceso_anterior = marco[1].nombre
            pagina_anterior = marco[2]
            Proceso.procesos[proceso_anterior].mover_a_disco(pagina_anterior)
        marco[1] = proceso
        marco[2] = pagina
        marco[3] = timestamp
        return marco[0]

    def fifo(self):
        return min(self.marcos, key=lambda x: x[-1])


class MemVir:

    def __init__(self, vir_size, mem_size, page_size):
        self.vir_size = vir_size
        self.mem_size = mem_size
        self.page_size = page_size
        self.controlador = None

    def simulacion(self, sec):
        memoria = MemFis(self.mem_size, self.page_size)
        procesos = {i: Proceso(i, self.vir_size, self.page_size)
                    for i in sec.split(',') if 'P' in i}
        instrucciones = sec.split(',')
        timestamp = 0
        for inst in instrucciones:
            if 'P' in inst:
                self.controlador = procesos[inst]
            else:
                n_pagina = int(inst) // self.controlador.page_size
                self.controlador._paginas_usadas.add(n_pagina)
                if not memoria.esta_mapeado(self.controlador, n_pagina):
                    self.controlador.page_faults += 1
                    n_marco = memoria.mapear(self.controlador,
                                             n_pagina, timestamp)
                    self.controlador.mapear(n_pagina, n_marco)
            timestamp += 1
        return procesos

    def __str__(self):
        return '\n'.join('%s: %s' % (k, v) for k, v in self.__dict__.items())


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('path')
    args = parser.parse_args()
    with open(args.path) as file:
        info = [line.strip().split('=')[1] for line in file.readlines()[:4]]
        info = [int(i) for i in info[0:3]] + info[3:]
        # print(info)
        memoria, sec = MemVir(*info[:-1]), info[-1]
        # print(memoria, '\n')
        for key, value in sorted(memoria.simulacion(sec).items()):
            print('Proceso', key + ':', value)
