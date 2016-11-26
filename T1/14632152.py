from argparse import ArgumentParser


def es_negativo(base, representacion):
    if base % 2 == 0:
        return representacion[0] >= base / 2
    numeros = representacion[::-1]
    while numeros:
        actual = numeros.pop()
        if actual < base // 2:
            return False
        if actual > base // 2:
            return True
    return False


def decimal(base, representacion):
    res = 0
    for i in range(len(representacion) - 1, -1, -1):
        res += representacion[i] * base ** (len(representacion) - i - 1)
    return res


def suma_carry(base, representacion, sumando):
    resultado = representacion[:]
    for i in range(len(representacion) - 1, -1, -1):
        if representacion[i] + sumando < base:
            resultado[i] = representacion[i] + sumando
            break
        resultado[i] = 0
    return resultado


def inverso_aditivo(base, representacion):
    inverso = []
    rep = [0] + representacion[:]
    comp = [base - i - 1 for i in rep][1:]
    inverso = suma_carry(base, comp, 1)
    if es_negativo(base, representacion):
        numero = -decimal(base, inverso)
    else:
        numero = decimal(base, representacion)
    return numero, inverso


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('path')
    args = parser.parse_args()
    with open(args.path) as file:
        for line in file:
            things = [int(i) for i in line.strip().split(',')]
            base, rep = things[0], things[1:]
            n, inv = inverso_aditivo(base, rep)
            rep_string = ", ".join([str(i) for i in rep])
            inv_string = ", ".join([str(i) for i in inv])
            print(rep_string, '(%d) ==>' % n, inv_string)
