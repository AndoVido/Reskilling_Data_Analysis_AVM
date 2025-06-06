import numpy
import string
import pyperclip

# Generador de contraseñas aleatorias
def generador_contrasenyes(longitud = 15, usar_mayusculas = True, usar_numeros = True, usar_simbolos = False):
    """
    Genera una contraseña aleatoria de la longitud especificada.
    Parámetros:
        longitud (int): Longitud de la contraseña a generar. Por defecto es 15.
        usar_mayusculas (bool): Indica si se deben incluir letras mayúsculas. Por defecto es True.
        usar_numeros (bool): Indica si se deben incluir números. Por defecto es True.
        usar_simbolos (bool): Indica si se deben incluir símbolos. Por defecto es False.
    salida:
        La contraseña generada.
    """
    char = list(string.ascii_lowercase)

    # lista de las contraseñas obligatorias y comprobaciones
    lista_obligatoria = []
    if longitud < 4:
        raise ValueError("la longitud mínima de la contraseña debe ser de 4 caracteres")
    if usar_simbolos:
        char += list(string.punctuation)
        lista_obligatoria.append(numpy.random.choice(list(string.punctuation)))
    if usar_mayusculas:
        char += list(string.ascii_uppercase)
        lista_obligatoria.append(numpy.random.choice(list(string.ascii_uppercase)))
    if usar_numeros:
        char += list(string.digits)
        lista_obligatoria.append(numpy.random.choice(list(string.digits)))

    # Generar la contraseña
    char = numpy.array(char)
    contrasenye = numpy.random.choice(char, longitud)
    contrasenye = numpy.array(list(contrasenye) + lista_obligatoria)   
    numpy.random.shuffle(contrasenye)
    contrasenye = list(contrasenye)

    # Asegurarse de que la contraseña contiene al menos caracteres en mayusculas 
    if usar_mayusculas:
        contrasenye[0] = contrasenye[0].upper()

    # Copiar al portapapeles
    pyperclip.copy("".join(contrasenye))
    print("La contraseña ha sido copiada al portapapeles.")
    return "".join(contrasenye) 
