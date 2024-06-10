import pandas as pd

arq = 'Rep1'

fonte = 'Puro/' + arq + '.csv'
destino = 'Tratado/' + arq + '.xlsx'

# Ler o arquivo csv
df = pd.read_csv(fonte)

# Escrever para um arquivo Excel
df.to_excel(destino, index=False)
