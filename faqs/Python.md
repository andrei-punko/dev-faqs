# Python — заметки

Ориентир: **Python 3**.

## Функции

```python
def имя_функции(параметры):
    выражение_1
    выражение_2
```

Параметры по умолчанию:

```python
def func(a, b="asd", c=0):
    ...
```

## Списки

`L = [1, 2, 3]` — индексация с нуля.

- **Копия:** `L2 = L1[:]`, `L2 = list(L1)` или `L1.copy()` (поверхностная).
- **Ссылка на тот же объект:** `L2 = L1`.

## Итерация по списку

| Задача | Пример |
|--------|--------|
| по элементам | `for x in L:` |
| по отсортированным | `for x in sorted(L):` |
| уникальные | `for x in set(L):` |
| в обратном порядке | `for x in reversed(L):` |
| элементы из `L`, которых нет в `L2` | `for item in set(L).difference(L2):` |

## Генераторы списков (list comprehension)

```python
a = [i * i for i in range(1, 10)]
a = [i * i for i in range(1, 10) if i % 2 == 0]
```

Распаковка последовательности:

```python
a, b = [1, 2]
```

## Методы и операции со списками

`append`, `extend`, `insert`, `index`, `count`, `remove`, `del L[i]`, `sort`, `reverse`, `pop()`, `pop(0)`, `len`, `max`, `min`, оператор `in`.

Не удалять элементы из списка во время итерации по нему — обычно собирают новый список или итерируют по копии.

## Кортеж (tuple)

Неизменяемая последовательность:

```python
L = (1, 2, 3)
L = 1, 2, 3
L = tuple("mama")
```

## Множество (set)

Неупорядоченная коллекция уникальных элементов; индексы и срезы не используются.

```python
s = set("abcde")
s.add(6)
s.remove("a")
```

Операции: `s1 - s2`, `s1 | s2`, `s1 & s2`, `s1 ^ s2`.

## `filter`, `map`, `zip`, `reduce`

В Python 3 `filter` и `map` возвращают **итераторы**; чтобы получить список: `list(...)`.

**Пример (простые числа до 100):**

```python
def is_prime(x):
    if x < 2:
        return False
    for y in range(2, int(x ** 0.5) + 1):
        if x % y == 0:
            return False
    return True

print(list(filter(is_prime, range(2, 100))))
```

На практике чаще используют генераторы: `[x for x in range(2, 100) if is_prime(x)]`.

**`map`:**

```python
def cube(x):
    return x * x * x

list(map(cube, range(1, 11)))
```

Параллельный обход нескольких последовательностей — через **`zip`**:

```python
seq1 = [1, 2, 3]
seq2 = [11, 12, 13]
for x, y in zip(seq1, seq2):
    print(x, y)
```

`zip` останавливается по **короткой** последовательности. Для дополнения до длины длинной — `itertools.zip_longest`.

**`reduce`** перенесён в модуль `functools`:

```python
from functools import reduce

def add(x, y):
    return x + y

reduce(add, range(1, 11))  # 55
```

Для суммы проще `sum(range(1, 11))`.

## Словарь (dict)

Ассоциативный массив: пары ключ–значение, ключи уникальны. С Python 3.7 порядок вставки ключей **гарантируется** языком.

Доступ по ключу, `del d[key]`, проверка **`key in d`**.

**Создание:**

```python
D = {"name": "mel", "age": 45}
D = {}
D["name"] = "mel"

d1 = dict(id=1948, name="Washer", size=3)
d2 = dict({"id": 1948, "name": "Washer", "size": 3})
d3 = dict([("id", 1948), ("name", "Washer"), ("size", 3)])
d4 = dict(zip(("id", "name", "size"), (1948, "Washer", 3)))

dict.fromkeys(["name", "age"], 123)

d = {x: x**2 for x in range(5)}
```

`dict()` с именованными аргументами удобен, когда ключи — допустимые идентификаторы; произвольные ключи — через литерал или `dict([...])`.

**Методы и функции:** `len(d)`, `d.clear()`, `d.copy()`, `copy.deepcopy(d)` из модуля `copy` для глубокой копии, `d.get(k, default)`, `d.items()`, `d.keys()`, `d.values()` (возвращают **представления**, а не отдельные копии-списки), `d.pop(k)`, `d.popitem()`, `d.update(d2)`.

К словарям не применяют `+` и срезы как к спискам.

## Модули и пакеты

Модуль — пространство имён (файл `.py`).

```python
import my_module
my_module.func1()

from my_module import func1, func2
func1()

from my_module import open as my_open
```

`import module` обычно предпочтительнее `from module import *` (меньше конфликтов имён). Для пакета нужен каталог с **`__init__.py`** (в Python 3.3+ может быть namespace package без него в особых случаях — см. документацию).

Повторная загрузка модуля:

```python
import importlib
importlib.reload(my_module)
```

Список имён в модуле: `dir(my_module)`.

## Классы (Python 3)

Все классы — **new-style**; явный `__metaclass__ = type` не нужен.

```python
class Sample:
    field1 = 15
    __field2 = 12  # соглашение об инкапсуляции (name mangling)

    def __init__(self, n):
        self.n = n

    def func(self, m):
        self.m = m
```

Метод можно привязать к классу снаружи:

```python
def method_for_simple(self, x, y):
    return x + y

class Simple:
    f = method_for_simple
```

Наследование:

```python
class Derived(Base):
    ...

class Derived(module_name.Base):
    ...
```

Вызов метода базового класса:

```python
class Barsik(Cat):
    def __init__(self):
        super().__init__()
        self.sound = "Aaaammm!"
```

Множественное наследование: `class Derived(Base1, Base2):`. Порядок разрешения — **MRO** (`Derived.__mro__`).

**`__str__`**, **`__repr__`** — строковое представление.

Полезные атрибуты класса: `__name__`, `__module__`, `__dict__`, `__bases__`, `__doc__`.

У экземпляра: `__dict__`, `__class__`.

Важные специальные методы (Python 3, кратко):

- жизненный цикл: `__init__`, `__del__` (редко нужен);
- сравнение: `__eq__`, `__lt__`, …;
- хеш: `__hash__`;
- доступ к атрибутам: `__getattr__`, `__getattribute__`, `__setattr__`, `__delattr__`;
- вызов экземпляра: `__call__`;
- контейнер: `__len__`, `__getitem__`, `__setitem__`, `__delitem__`, `__contains__`;
- срезы: через `__getitem__(self, key)` с объектом `slice`.

Числовые преобразования: `__int__`, `__float__`, `__complex__` и т.д.

## Статические и методы класса

```python
class Multi:
    def imeth(self, x):
        print(self, x)

    @staticmethod
    def smeth(x):
        print(x)

    @classmethod
    def cmeth(cls, x):
        print(cls, x)
```

## Итератор

Нужны `__iter__` и **`__next__`**.

```python
class Reverse:
    def __init__(self, data):
        self.data = data
        self.index = len(data)

    def __iter__(self):
        return self

    def __next__(self):
        if self.index == 0:
            raise StopIteration
        self.index -= 1
        return self.data[self.index]


for char in Reverse("12345"):
    print(char)

rvr = list(Reverse("12345"))
```

## `property`

```python
class DateOffset:
    def __init__(self):
        self.start = 0

    def _get_offset(self):
        self.start += 5
        return self.start

    offset = property(_get_offset)
```

Современный стиль — декоратор `@property` и `@offset.setter`.

## `__slots__`

Ограничивает набор атрибутов экземпляра и может экономить память:

```python
class Limiter:
    __slots__ = ("age", "name", "job")

x = Limiter()
x.age = 20
```

## Функтор

Класс с методом `__call__` — экземпляр можно вызывать как функцию.

## Дескриптор

Класс с `__get__`, `__set__` и/или `__delete__` — используется для контроля доступа к атрибутам (как `property`, методы класса и т.д.).

## Упрощённая «последовательность»

Пример с `__getitem__` / `__setitem__` из оригинальных заметок — по смыслу тот же; для полноценной последовательности обычно добавляют `__len__` и при необходимости поддержку срезов в `__getitem__`.

## Файлы

```python
with open("my_file", "r", encoding="utf-8") as f:
    chunk = f.read(5)
    rest = f.read()
```

Режимы: `r`, `w`, `a`, `b`, `+` (к комбинациям). Для текстовых файлов указывайте **`encoding`**, если не UTF-8.

Построчно: `for line in f:`, `f.readline()`, `f.readlines()` (осторожно с памятью на больших файлах). Запись: `f.write(...)`, `f.writelines(...)`.

«Файлоподобные» объекты: `sys.stdin`, `sys.stdout`; для URL в Python 3 — `urllib.request.urlopen(...)` (контекстный менеджер и чтение зависят от типа ответа).

## `pickle`

```python
import pickle

t1 = [1, 2, 3]
s = pickle.dumps(t1)
t2 = pickle.loads(s)
```

`t1` и `t2` — разные объекты с одинаковым содержимым. Не загружайте pickle из недоверенных источников.

## `struct` (бинарные данные)

```text
Format   C type      Python
c        char        bytes длины 1
?        _Bool       bool
i        int         int
l        long        int
f        float       float
d        double      float
s        char[]      bytes
```

```python
from struct import pack, unpack, calcsize

with open("123.bin", "wb") as out:
    fmt = "if5s"
    data = pack(fmt, 24, 12.48, b"12345")
    out.write(data)

with open("123.bin", "rb") as inp:
    data = inp.read()

fmt = "if5s"
value, value2, value3 = unpack(fmt, data)
calcsize(fmt)
```

Для строк в формате `s` в Python 3 обычно используют **bytes**.

## Файловая система (`os`, `os.path`)

```python
import os

os.getcwd()
os.path.exists("my_file")
os.listdir(path)
os.path.join(directory, name)
os.path.isfile(path)
```

Обход дерева каталогов — **`os.walk(top)`**.

Удобная альтернатива — **`pathlib.Path`** (`path.read_text()`, `path.iterdir()`, и т.д.).

## Мелочи

- Логические значения: `True`, `False`.
- **`IndentationError`:** проверить смесь табов и пробелов, включить отображение непечатаемых символов в редакторе.
- Обрезка пробелов: `s.strip()`, `s.rstrip()`, `s.lstrip()`, `s.strip(" \t\n\r")`.
- Длина строки: `len(s)` (не `s.__len__()` без нужды).
- Инкремента `++` в Python нет; используйте `+= 1`.

## pip и окружения

- Установка пакетов: `python -m pip install ...`.
- Виртуальное окружение: `python -m venv .venv` и активация по ОС.

Если используете **embedded** сборку Python на Windows и после `get-pip.py` нет `pip`, может понадобиться правка `pythonXX._pth` (добавить `Lib\site-packages`) — см. [обсуждение на Stack Overflow](https://stackoverflow.com/questions/32639074/why-am-i-getting-importerror-no-module-named-pip-right-after-installing-pip).
