import re

import gspread
from oauth2client.service_account import ServiceAccountCredentials

# DOC_URL = 'https://docs.google.com/spreadsheets/d/1I18tw65uKFNbfwJKEmPpKX5EHF0rvS7hc6HQ890j_58/edit#gid=1436316114'
# DOC_URL = 'https://docs.google.com/spreadsheets/d/1_xXmr2hWpU0u46ipXLh9Rnkkbki1hN_-MnvjoxsJhNw/edit?gid=0#gid=0'
# DOC_URL = 'https://docs.google.com/spreadsheets/d/1Yhcbr8rKB9LQNxr1dq0_duqIzLxk8DbIPIzfqlHJrB8/edit?gid=438177093#gid=438177093' # error
# DOC_URL = 'https://docs.google.com/spreadsheets/d/1bcUMNWrVsfNHj7EabdgxUt8h143GCRrIuulypMPvZgY/edit?gid=1367059653#gid=1367059653'
# DOC_URL = 'https://docs.google.com/spreadsheets/d/1o_M4lopQEifmjpyhoAHB6847drNaoVMjTzL5p46ukW4/edit?gid=1803345319#gid=1803345319'
# DOC_URL = 'https://docs.google.com/spreadsheets/d/1_xXmr2hWpU0u46ipXLh9Rnkkbki1hN_-MnvjoxsJhNw/edit?gid=0#gid=0'
# DOC_URL = 'https://docs.google.com/spreadsheets/d/18Jm-BDRsWVJvpHDglQzUajEh1rHQxoNqSOnYFjDrelY/edit?gid=372578189#gid=372578189'
DOC_URL = 'https://docs.google.com/spreadsheets/d/1x2soN01W0vEXRtaFDFi2-B7pEuVVuP_5MiahSmVlQFc/edit?pli=1&gid=1651427486#gid=1651427486'

# CELL_RANGE = 'E2:E91'
# CELL_RANGE = 'D2:D134'
# CELL_RANGE = 'E2:E71'
# CELL_RANGE = 'E2:E86'
# CELL_RANGE = 'E2:E89'
# CELL_RANGE = 'D2:D134'
# CELL_RANGE = 'C2:C81'
CELL_RANGE = 'C2:C71'

PREFIX = 'https://wrench.edu.swampbuds.me/result'

scope = [
    'https://www.googleapis.com/auth/spreadsheets.readonly',
    'https://www.googleapis.com/auth/drive.readonly'
]
creds = ServiceAccountCredentials.from_json_keyfile_name('creds.json', scope)
client = gspread.authorize(creds)

spreadsheet = client.open_by_url(DOC_URL)
sheet = spreadsheet.sheet1

cells = sheet.range(CELL_RANGE)

url_pattern = re.compile(r'https?://\S+')

urls = [
    u
    for cell in cells if cell.value
    for u in url_pattern.findall(cell.value)
    if u.startswith(PREFIX)
]

print('\n'.join(urls))

with open('urls.txt', 'a', encoding='utf-8') as f:
    for url in urls:
        f.write(url + '\n')

print(f'Добавлено {len(urls)} ссылок в urls.txt')
