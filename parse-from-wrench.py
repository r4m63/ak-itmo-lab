import re
from pathlib import Path
from typing import Optional

import requests
from bs4 import BeautifulSoup

URLS_FILE = 'urls.txt'
OUTPUT_ROOT = '.'
REQUEST_TIMEOUT = 20
COMMON_DATA_ATTRS = (
    'data-code', 'data-line', 'data-text', 'data-clipboard-text',
)


def _collect_code_lines(container):
    if not container:
        return ''
    lines = []
    for div in container.find_all('div', class_='code-line', recursive=False):
        txt = div.get_text(strip=False)
        if not txt.strip():
            for attr in COMMON_DATA_ATTRS:
                if div.has_attr(attr):
                    txt = div[attr]
                    break
        lines.append(txt.rstrip('\n'))
    return '\n'.join(lines).rstrip()


def _next_free_pair(path_s: Path, path_y: Path):
    if not (path_s.exists() or path_y.exists()):
        return path_s, path_y

    n = 2
    while True:
        new_s = path_s.parent / f'{path_s.stem}({n}){path_s.suffix}'
        new_y = path_y.parent / f'{path_y.stem}({n}){path_y.suffix}'
        if not (new_s.exists() or new_y.exists()):
            return new_s, new_y
        n += 1


def parse_wrench_result(url: str) -> Optional[dict]:
    try:
        html = requests.get(url, timeout=REQUEST_TIMEOUT).text
    except Exception as exc:
        print(f'[!] HTTP-ошибка для {url}: {exc}')
        return None

    soup = BeautifulSoup(html, 'html.parser')

    variant_m = re.search(r'/\*\s*variant:\s*([^\s*]+)', html)
    isa_m = re.search(r'--isa\s+([^\s]+)', html)
    if not (variant_m and isa_m):
        print(f'[!] Не нашли variant/isa в {url}')
        return None

    asm_wrap = soup.find(id='assembler-code-text-element')
    sim_wrap = soup.find(id='simulation-config-text-element')

    assembler = _collect_code_lines(asm_wrap.find(class_='code-content') if asm_wrap else None)
    sim_cfg = _collect_code_lines(sim_wrap.find(class_='code-content') if sim_wrap else None)

    if not (assembler and sim_cfg):
        print(f'[!] Пустой assembler_code или simulation_config для {url}')
        return None

    return {
        'variant': variant_m.group(1),
        'isa': isa_m.group(1),
        'assembler_code': assembler,
        'simulation_config': sim_cfg,
    }


def save_pair(data: dict, root: Path = Path(OUTPUT_ROOT)):
    isa_dir = root / data['isa']
    isa_dir.mkdir(parents=True, exist_ok=True)

    base_s = isa_dir / f"{data['variant']}.s"
    base_yml = isa_dir / f"{data['variant']}.yml"
    path_s, path_yml = _next_free_pair(base_s, base_yml)

    path_s.write_text(data['assembler_code'] + '\n', encoding='utf-8')
    path_yml.write_text(data['simulation_config'] + '\n', encoding='utf-8')

    print(f'  → {path_s.relative_to(root)}')
    print(f'  → {path_yml.relative_to(root)}')


def main():
    f = Path(URLS_FILE)
    if not f.is_file():
        print(f'Файл {URLS_FILE} не найден.')
        return
    urls = [u.strip() for u in f.read_text().splitlines() if u.strip()]
    if not urls:
        print('В файле нет URL-ов.')
        return

    print(f'Обработка {len(urls)} ссылок…\n')
    for u in urls:
        print(u)
        parsed = parse_wrench_result(u)
        if parsed:
            save_pair(parsed, Path(OUTPUT_ROOT))
        print()
    print('Готово.')


if __name__ == '__main__':
    main()
