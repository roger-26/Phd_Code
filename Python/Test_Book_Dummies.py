if __name__ == '__main__':
    first_name = "Alan2"
    print(len(first_name))
    middle_init = "C."
    last_name = "Simpson"
    full_name = first_name + " " + middle_init + " " + last_name
    print(full_name)
    print(len(full_name))
    y = full_name.index("Si")
    x = full_name.index("on")
    z = full_name.count("o")
    y = full_name.count("n")
    s = "Abracadabra Hocus Pocus you're a turtle dove"
    print("t" in s)
    #imprimir cada 3er caracter
    print(s[0:44:3])
    #Donde esta la primer o minuscula en los caracteres 22 a 44
    print(s.index("o",22,44))
    pass
