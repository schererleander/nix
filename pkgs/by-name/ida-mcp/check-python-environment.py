import importlib.util
import pathlib
import sys

sys.executable = sys.argv[1]
import site
site.main()

assert pathlib.Path(sys.prefix) == pathlib.Path(sys.executable).parent.parent
assert sys.prefix != sys.base_prefix
for name in ("ida_nexus", "ida_domain", "rpyc", "pip"):
    assert importlib.util.find_spec(name) is not None, name
import ida_nexus
import rpyc
