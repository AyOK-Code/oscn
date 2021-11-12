# Define constant from ENV variable
CASE_TYPES = ENV.fetch('CASE_TYPES_ABBREVIATION', 'CF,CM,TR,TRI,AM,CPC,DTR').split(',')
